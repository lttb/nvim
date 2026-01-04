# @see https://github.com/olimorris/codecompanion.nvim/discussions/1984#discussioncomment-14803734

local anthropic = require('codecompanion.adapters.http.anthropic')
local config = require('codecompanion.config')
local curl = require('plenary.curl')
local log = require('codecompanion.utils.log')

-- Module-level OAuth token cache
local _access_token = nil
local _token_loaded = false

-- Configuration for automatic token refresh
local REFRESH_CONFIG = {
  auto_refresh_enabled = true, -- Enable automatic token refresh
  refresh_buffer_minutes = 5,  -- Refresh token 5 minutes before expiration
  max_retry_attempts = 2,      -- Maximum number of retry attempts for refresh
}

-- OAuth flow constant configuration
local OAUTH_CONFIG = {
  CLIENT_ID = '9d1c250a-e61b-44d9-88ed-5944d1962f5e',                            -- OAuth client ID
  REDIRECT_URI = 'https://console.anthropic.com/oauth/code/callback',            -- Authorization callback URL
  AUTH_URL = 'https://claude.ai/oauth/authorize',                                -- Same as Claude CLI
  TOKEN_URL = 'https://api.anthropic.com/v1/oauth/token',                        -- Token exchange URL
  API_KEY_URL = 'https://api.anthropic.com/api/oauth/claude_cli/create_api_key', -- API key creation URL
  SCOPES = 'org:create_api_key user:profile user:inference',                     -- Same as Claude CLI
}

-- URL encoding function for building OAuth URL parameters
---@param str string
---@return string
local function url_encode(str)
  if str then
    str = string.gsub(str, '\n', '\r\n')
    str = string.gsub(str, '([^%w %-%_%.%~])', function(c)
      return string.format('%%%02X', string.byte(c))
    end)
    str = string.gsub(str, ' ', '+')
  end
  return str
end

-- Generate cryptographically secure random string for PKCE
-- PKCE (Proof Key for Code Exchange) is a security extension for OAuth 2.0
---@param length number
---@return string
local function generate_random_string(length)
  local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
  local result = {}

  ---@diagnostic disable-next-line: undefined-field
  math.randomseed(os.time() + (vim.loop and vim.loop.hrtime() or 0))

  for _ = 1, length do
    local rand_index = math.random(1, #chars)
    table.insert(result, chars:sub(rand_index, rand_index))
  end
  return table.concat(result)
end

-- Generate SHA256 hash required for PKCE challenge (base64url format)
---@param input string
---@return string
local function sha256_base64url(input)
  -- Use printf instead of echo -n for better compatibility
  local cmd = string.format(
    "printf '%%s' '%s' | openssl dgst -sha256 -binary | base64 | tr '+/' '-_' | tr -d '='",
    input:gsub("'", "'\\''")
  )

  local handle = io.popen(cmd)
  if handle then
    local result = handle:read('*a')
    handle:close()
    if result and #result > 0 then
      return result:gsub('[\n\r]', '')
    end
  end

  -- Fallback: Use vim's sha256 properly
  local hex_hash = vim.fn.sha256(input)
  local binary = ''
  for i = 1, #hex_hash, 2 do
    local byte = tonumber(hex_hash:sub(i, i + 1), 16)
    binary = binary .. string.char(byte)
  end
  local base64 = vim.base64.encode(binary)
  ---@diagnostic disable-next-line: redundant-return-value
  return base64:gsub('[+/=]', { ['+'] = '-', ['/'] = '_', ['='] = '' })
end

-- Generate PKCE code verifier and challenge
---@return { verifier: string, challenge: string }
local function generate_pkce()
  local verifier = generate_random_string(128) -- Use maximum length to improve security
  local challenge = sha256_base64url(verifier)
  return {
    verifier = verifier,
    challenge = challenge,
  }
end

-- Find data path for storing OAuth tokens
-- Support custom path via environment variables
---@return string|nil
local function find_data_path()
  -- First check environment variables
  local env_path = os.getenv('CODECOMPANION_ANTHROPIC_TOKEN_PATH')
  if env_path and vim.fn.isdirectory(vim.fs.dirname(env_path)) > 0 then
    return vim.fs.dirname(env_path)
  end

  -- Use Neovim data directory (cross-platform compatible)
  local nvim_data = vim.fn.stdpath('data')
  if nvim_data and vim.fn.isdirectory(nvim_data) > 0 then
    return nvim_data
  end

  return nil
end

-- Get OAuth token file path
-- Use cross-platform path separator
---@return string|nil
local function get_token_file_path()
  local data_path = find_data_path()
  if not data_path then
    log:error('Anthropic OAuth: Unable to determine data directory')
    return nil
  end

  -- Use vim.fs.joinpath to ensure cross-platform path compatibility
  local path_sep = package.config:sub(1, 1) -- Get system path separator
  return data_path .. path_sep .. 'anthropic_oauth.json'
end

-- Load OAuth token data from file
---@return table|nil
local function load_token_data()
  local token_file = get_token_file_path()
  if not token_file or vim.fn.filereadable(token_file) == 0 then
    return nil
  end

  local success, content = pcall(vim.fn.readfile, token_file)
  if not success or not content or #content == 0 then
    log:debug('Anthropic OAuth: Unable to read token file or file is empty')
    return nil
  end

  local decode_success, data = pcall(vim.json.decode, table.concat(content, '\n'))
  if decode_success and data and data.access_token then
    return data
  else
    log:warn('Anthropic OAuth: Invalid token file format')
    return nil
  end
end

-- Check if token is expired
---@param token_data table
---@return boolean
local function is_token_expired(token_data)
  if not token_data or not token_data.expires_at then
    return false -- If no expiration time, assume it's still valid
  end

  local current_time = os.time()
  -- Add configurable buffer to refresh before actual expiration
  local buffer_seconds = REFRESH_CONFIG.refresh_buffer_minutes * 60
  return current_time >= (token_data.expires_at - buffer_seconds)
end

-- Load OAuth access token from file (no automatic refresh)
---@return string|nil
local function load_access_token()
  local token_data = load_token_data()
  if not token_data then
    _token_loaded = true
    _access_token = nil
    return nil
  end

  -- Check if token is expired
  if is_token_expired(token_data) then
    -- Load the token data again and check for refresh token
    if not token_data.refresh_token then
      log:warn(
        'Anthropic OAuth: Access token expired and no refresh token available. Please run :AnthropicOAuthSetup to re-authenticate'
      )
      _access_token = nil
      _token_loaded = true
      return nil
    end

    -- Return nil to indicate token is expired - refresh will happen later
    _access_token = nil
    _token_loaded = true
    return nil
  end

  _access_token = token_data.access_token
  _token_loaded = true
  return token_data.access_token
end

-- Save OAuth tokens to file
---@param token_data table Token data containing access_token, refresh_token, expires_in
---@return boolean
local function save_tokens(token_data)
  if not token_data or not token_data.access_token then
    log:error('Anthropic OAuth: Cannot save empty access token')
    return false
  end

  local token_file = get_token_file_path()
  if not token_file then
    return false
  end

  local current_time = os.time()
  local expires_at = nil

  -- Calculate expiration time if expires_in is provided
  if token_data.expires_in and type(token_data.expires_in) == 'number' then
    expires_at = current_time + token_data.expires_in
  end

  local data = {
    access_token = token_data.access_token,
    refresh_token = token_data.refresh_token,
    expires_at = expires_at,
    created_at = current_time,
    version = 1, -- Version number for potential future data migration
  }

  local success, err = pcall(function()
    vim.fn.writefile({ vim.json.encode(data) }, token_file)
  end)

  if success then
    _access_token = token_data.access_token
    _token_loaded = true
    log:info('Anthropic OAuth: Tokens saved successfully')
    return true
  else
    log:error('Anthropic OAuth: Failed to save tokens: %s', err or 'unknown error')
    return false
  end
end

-- Refresh access token using refresh token
---@param refresh_token string
---@return table|nil
local function refresh_access_token(refresh_token)
  if not refresh_token or refresh_token == '' then
    log:error('Anthropic OAuth: Refresh token required')
    return nil
  end

  log:debug('Anthropic OAuth: Refreshing access token')

  local request_data = {
    grant_type = 'refresh_token',
    refresh_token = refresh_token,
    client_id = OAUTH_CONFIG.CLIENT_ID,
  }

  local response = curl.post(OAUTH_CONFIG.TOKEN_URL, {
    headers = {
      ['Content-Type'] = 'application/json',
    },
    body = vim.json.encode(request_data),
    insecure = (config.adapters and config.adapters.opts and config.adapters.opts.allow_insecure) or false,
    proxy = (config.adapters and config.adapters.opts and config.adapters.opts.proxy) or nil,
    timeout = 30000,
    on_error = function(err)
      log:error('Anthropic OAuth: Token refresh request error: %s', vim.inspect(err))
    end,
  })

  if not response then
    log:error('Anthropic OAuth: Token refresh request no response')
    return nil
  end

  if response.status >= 400 then
    log:error('Anthropic OAuth: Token refresh failed, status code %d: %s', response.status, response.body or 'no body')
    return nil
  end

  local decode_success, token_data = pcall(vim.json.decode, response.body)
  if not decode_success or not token_data or not token_data.access_token then
    log:error('Anthropic OAuth: Invalid token refresh response format')
    return nil
  end

  log:debug('Anthropic OAuth: Successfully refreshed access token')
  return token_data
end

-- Attempt automatic token refresh with error handling
---@param token_data table The current token data containing refresh_token
---@return string|nil The new access token if refresh was successful
local function attempt_automatic_refresh(token_data)
  -- Check if automatic refresh is enabled
  if not REFRESH_CONFIG.auto_refresh_enabled then
    log:debug('Anthropic OAuth: Automatic token refresh is disabled')
    return nil
  end

  if not token_data or not token_data.refresh_token then
    return nil
  end

  -- Attempt refresh with retry logic
  local max_attempts = REFRESH_CONFIG.max_retry_attempts
  local new_token_data = nil

  for attempt = 1, max_attempts do
    log:debug('Anthropic OAuth: Attempting automatic token refresh (attempt %d/%d)', attempt, max_attempts)
    new_token_data = refresh_access_token(token_data.refresh_token)

    if new_token_data then
      break
    end

    if attempt < max_attempts then
      log:debug('Anthropic OAuth: Refresh attempt %d failed, retrying...', attempt)
      -- Brief delay before retry (1 second)
      vim.defer_fn(function() end, 1000)
    end
  end

  if not new_token_data then
    log:warn('Anthropic OAuth: Automatic token refresh failed after %d attempts', max_attempts)
    return nil
  end

  -- Preserve refresh token if not returned in response
  if not new_token_data.refresh_token and token_data.refresh_token then
    new_token_data.refresh_token = token_data.refresh_token
  end

  if save_tokens(new_token_data) then
    log:info('Anthropic OAuth: Token automatically refreshed successfully')
    return new_token_data.access_token
  else
    log:error('Anthropic OAuth: Failed to save automatically refreshed token')
    return nil
  end
end

-- Configure automatic token refresh behavior
---@param refresh_config table Configuration options for automatic refresh
local function configure_auto_refresh(refresh_config)
  if refresh_config.auto_refresh_enabled ~= nil then
    REFRESH_CONFIG.auto_refresh_enabled = refresh_config.auto_refresh_enabled
  end
  if refresh_config.refresh_buffer_minutes and type(refresh_config.refresh_buffer_minutes) == 'number' then
    REFRESH_CONFIG.refresh_buffer_minutes = math.max(1, refresh_config.refresh_buffer_minutes)
  end
  if refresh_config.max_retry_attempts and type(refresh_config.max_retry_attempts) == 'number' then
    REFRESH_CONFIG.max_retry_attempts = math.max(1, refresh_config.max_retry_attempts)
  end

  log:info(
    'Anthropic OAuth: Auto-refresh configuration updated - enabled: %s, buffer: %d minutes, max retries: %d',
    tostring(REFRESH_CONFIG.auto_refresh_enabled),
    REFRESH_CONFIG.refresh_buffer_minutes,
    REFRESH_CONFIG.max_retry_attempts
  )
end

-- Exchange authorization code for access token (no API key creation)
---@param code string
---@param verifier string
---@return string|nil
local function exchange_code_for_token(code, verifier)
  if not code or code == '' or not verifier or verifier == '' then
    log:error('Anthropic OAuth: Authorization code and verifier required')
    return nil
  end

  log:debug('Anthropic OAuth: Exchanging authorization code for access token')

  -- Parse authorization code and state from callback URL fragment
  local code_parts = vim.split(code, '#')
  local auth_code = code_parts[1]
  local state = code_parts[2] or verifier

  local request_data = {
    code = auth_code,
    state = state,
    grant_type = 'authorization_code',
    client_id = OAUTH_CONFIG.CLIENT_ID,
    redirect_uri = OAUTH_CONFIG.REDIRECT_URI,
    code_verifier = verifier,
    scope = OAUTH_CONFIG.SCOPES,
  }

  log:debug('Anthropic OAuth: Token exchange request initiated')

  local response = curl.post(OAUTH_CONFIG.TOKEN_URL, {
    headers = {
      ['Content-Type'] = 'application/json',
    },
    body = vim.json.encode(request_data),
    insecure = (config.adapters and config.adapters.opts and config.adapters.opts.allow_insecure) or false,
    proxy = (config.adapters and config.adapters.opts and config.adapters.opts.proxy) or nil,
    timeout = 30000, -- 30 second timeout
    on_error = function(err)
      log:error('Anthropic OAuth: Token exchange request error: %s', vim.inspect(err))
    end,
  })

  if not response then
    log:error('Anthropic OAuth: Token exchange request no response')
    return nil
  end

  if response.status >= 400 then
    log:error('Anthropic OAuth: Token exchange failed, status code %d: %s', response.status, response.body or 'no body')
    return nil
  end

  local decode_success, token_data = pcall(vim.json.decode, response.body)
  if not decode_success or not token_data or not token_data.access_token then
    log:error('Anthropic OAuth: Invalid token response format')
    return nil
  end

  log:debug('Anthropic OAuth: Successfully obtained access token')

  -- Save tokens (access token and refresh token if available)
  if save_tokens(token_data) then
    return token_data.access_token
  end

  return nil
end

-- Generate OAuth authorization URL with PKCE
---@return { url: string, verifier: string }
local function generate_auth_url()
  local pkce = generate_pkce()

  -- Build correctly encoded and ordered query string
  local query_params = {
    'code=true',
    'client_id=' .. url_encode(OAUTH_CONFIG.CLIENT_ID),
    'response_type=code',
    'redirect_uri=' .. url_encode(OAUTH_CONFIG.REDIRECT_URI),
    'scope=' .. url_encode(OAUTH_CONFIG.SCOPES),
    'code_challenge=' .. url_encode(pkce.challenge),
    'code_challenge_method=S256',
    'state=' .. url_encode(pkce.verifier),
  }

  local auth_url = OAUTH_CONFIG.AUTH_URL .. '?' .. table.concat(query_params, '&')
  log:debug('Anthropic OAuth: Generated authorization URL: %s', auth_url)
  log:debug('Anthropic OAuth: Scopes: %s', OAUTH_CONFIG.SCOPES)

  return {
    url = auth_url,
    verifier = pkce.verifier,
  }
end

-- Get access token from cache or file
---@param force_refresh boolean|nil Force refresh even if token appears valid
---@return string|nil
local function get_access_token(force_refresh)
  -- If force refresh is requested, clear cache
  if force_refresh then
    _token_loaded = false
    _access_token = nil
  end

  -- Return cached token if valid and no force refresh
  if not force_refresh and _token_loaded and _access_token then
    -- Still need to check if cached token is expired
    local token_data = load_token_data()
    if token_data and not is_token_expired(token_data) then
      return _access_token
    else
      -- Token is expired, try to refresh automatically
      _token_loaded = false
      _access_token = nil

      -- Attempt automatic refresh if refresh token is available
      local refreshed_token = attempt_automatic_refresh(token_data)
      if refreshed_token then
        return refreshed_token
      else
        if token_data and token_data.refresh_token then
          log:warn(
            'Anthropic OAuth: Automatic token refresh failed. Please run :AnthropicOAuthRefresh to refresh manually or :AnthropicOAuthSetup to re-authenticate'
          )
        else
          log:warn(
            'Anthropic OAuth: Cached token expired and no refresh token available. Please run :AnthropicOAuthSetup to re-authenticate'
          )
        end
        return nil
      end
    end
  end

  -- Try to load from file (no automatic refresh)
  local access_token = load_access_token()
  if not access_token then
    -- Try automatic refresh if token is expired but refresh token exists
    local token_data = load_token_data()
    if token_data and is_token_expired(token_data) and token_data.refresh_token then
      local refreshed_token = attempt_automatic_refresh(token_data)
      if refreshed_token then
        return refreshed_token
      else
        log:warn(
          'Anthropic OAuth: Automatic token refresh failed. Please run :AnthropicOAuthRefresh to refresh manually or :AnthropicOAuthSetup to re-authenticate'
        )
        return nil
      end
    end

    -- Need new OAuth flow
    log:error('Anthropic OAuth: Access token not found or invalid. Please run :AnthropicOAuthSetup to authenticate')
    return nil
  end

  return access_token
end

-- Setup OAuth authentication (interactive)
---@return boolean
local function setup_oauth()
  local auth_data = generate_auth_url()

  vim.notify('Opening Anthropic OAuth authentication in browser...', vim.log.levels.INFO)

  -- Open URL in default browser (cross-platform handling)
  local open_cmd
  if vim.fn.has('mac') == 1 then
    open_cmd = 'open'
  elseif vim.fn.has('unix') == 1 then
    -- Linux system, try xdg-open first
    open_cmd = 'xdg-open'
    -- If xdg-open doesn't exist, try other common commands
    if vim.fn.executable('xdg-open') == 0 then
      if vim.fn.executable('gnome-open') == 1 then
        open_cmd = 'gnome-open'
      elseif vim.fn.executable('kde-open') == 1 then
        open_cmd = 'kde-open'
      end
    end
  elseif vim.fn.has('win32') == 1 then
    -- Windows needs special handling, use cmd /c start
    open_cmd = 'cmd /c start ""'
  end

  if open_cmd then
    local cmd
    if vim.fn.has('win32') == 1 then
      -- Windows: use double quotes and escape special characters
      cmd = open_cmd .. ' "' .. auth_data.url:gsub('&', '^&') .. '"'
    else
      -- Unix/Mac: use single quotes
      cmd = open_cmd .. " '" .. auth_data.url .. "'"
    end

    local success = pcall(vim.fn.system, cmd)
    if not success then
      vim.notify(
        'Unable to automatically open browser. Please manually open this URL:\n' .. auth_data.url,
        vim.log.levels.WARN
      )
    end
  else
    vim.notify('Please open this URL in your browser:\n' .. auth_data.url, vim.log.levels.INFO)
  end

  -- Prompt user to enter authorization code
  vim.ui.input({
    prompt = "Please enter the authorization code from the callback URL (the part after 'code='):",
  }, function(code)
    if not code or code == '' then
      vim.notify('OAuth setup cancelled', vim.log.levels.WARN)
      return
    end

    -- Show progress
    vim.notify('Exchanging authorization code for access token...', vim.log.levels.INFO)

    local access_token = exchange_code_for_token(code, auth_data.verifier)
    if access_token then
      vim.notify('Anthropic OAuth authentication successful! Access token saved.', vim.log.levels.INFO)
    else
      vim.notify('Anthropic OAuth authentication failed. Please check logs and retry.', vim.log.levels.ERROR)
    end
  end)

  return true
end

-- Create user commands for OAuth management
vim.api.nvim_create_user_command('AnthropicOAuthSetup', function()
  setup_oauth()
end, {
  desc = 'Setup Anthropic OAuth authentication',
})

vim.api.nvim_create_user_command('AnthropicOAuthStatus', function()
  local token_data = load_token_data()
  if not token_data or not token_data.access_token then
    vim.notify('Anthropic access token not found. Run :AnthropicOAuthSetup to authenticate.', vim.log.levels.WARN)
    return
  end

  local status_msg = 'Anthropic access token is configured and available.\n'

  -- Add auto-refresh configuration status
  status_msg = status_msg
      .. string.format(
        'Auto-refresh: %s (buffer: %d min, max retries: %d)\n',
        REFRESH_CONFIG.auto_refresh_enabled and 'enabled' or 'disabled',
        REFRESH_CONFIG.refresh_buffer_minutes,
        REFRESH_CONFIG.max_retry_attempts
      )

  if token_data.expires_at then
    local current_time = os.time()
    local expires_in_seconds = token_data.expires_at - current_time

    if expires_in_seconds <= 0 then
      status_msg = status_msg .. '⚠️  Token is expired.'
      if token_data.refresh_token then
        status_msg = status_msg .. ' Will attempt to refresh on next use.\n'
      else
        status_msg = status_msg .. ' No refresh token available - please re-authenticate.\n'
      end
    elseif expires_in_seconds < 3600 then -- Less than 1 hour
      local expires_in_minutes = math.floor(expires_in_seconds / 60)
      status_msg = status_msg .. string.format('⚠️  Token expires in %d minutes.\n', expires_in_minutes)
    elseif expires_in_seconds < 86400 then -- Less than 24 hours
      local expires_in_hours = math.floor(expires_in_seconds / 3600)
      status_msg = status_msg .. string.format('Token expires in %d hours.\n', expires_in_hours)
    else
      local expires_in_days = math.floor(expires_in_seconds / 86400)
      status_msg = status_msg .. string.format('Token expires in %d days.\n', expires_in_days)
    end
  end

  if token_data.refresh_token then
    status_msg = status_msg .. 'Refresh token available.'
  else
    status_msg = status_msg .. '⚠️  No refresh token - will need to re-authenticate when expired.'
  end

  vim.notify(status_msg, vim.log.levels.INFO)
end, {
  desc = 'Check Anthropic OAuth access token status',
})

vim.api.nvim_create_user_command('AnthropicOAuthRefresh', function()
  local token_data = load_token_data()
  if not token_data or not token_data.refresh_token then
    vim.notify('No refresh token available. Please run :AnthropicOAuthSetup to re-authenticate.', vim.log.levels.WARN)
    return
  end

  vim.notify('Refreshing Anthropic OAuth token...', vim.log.levels.INFO)

  local refreshed_token = attempt_automatic_refresh(token_data)
  if refreshed_token then
    _access_token = refreshed_token
    _token_loaded = true
    vim.notify('Anthropic OAuth token refreshed successfully!', vim.log.levels.INFO)
  else
    vim.notify('Failed to refresh token. Please run :AnthropicOAuthSetup to re-authenticate.', vim.log.levels.ERROR)
  end
end, {
  desc = 'Manually refresh Anthropic OAuth access token',
})

vim.api.nvim_create_user_command('AnthropicOAuthClear', function()
  local token_file = get_token_file_path()
  if token_file and vim.fn.filereadable(token_file) == 1 then
    local success = pcall(vim.fn.delete, token_file)
    if success then
      _access_token = nil
      _token_loaded = false
      vim.notify('Anthropic access token cleared.', vim.log.levels.INFO)
    else
      vim.notify('Failed to clear access token file.', vim.log.levels.ERROR)
    end
  else
    vim.notify('No Anthropic access token to clear.', vim.log.levels.WARN)
  end
end, {
  desc = 'Clear stored Anthropic OAuth access token',
})

vim.api.nvim_create_user_command('AnthropicOAuthConfig', function(opts)
  local args = opts.fargs
  if #args == 0 then
    -- Show current configuration
    local config_msg = string.format(
      'Anthropic OAuth Auto-refresh Configuration:\n'
      .. '• Enabled: %s\n'
      .. '• Buffer time: %d minutes\n'
      .. '• Max retry attempts: %d\n\n'
      .. 'Usage examples:\n'
      .. ':AnthropicOAuthConfig enable\n'
      .. ':AnthropicOAuthConfig disable\n'
      .. ':AnthropicOAuthConfig buffer 10\n'
      .. ':AnthropicOAuthConfig retries 3',
      REFRESH_CONFIG.auto_refresh_enabled and 'true' or 'false',
      REFRESH_CONFIG.refresh_buffer_minutes,
      REFRESH_CONFIG.max_retry_attempts
    )
    vim.notify(config_msg, vim.log.levels.INFO)
    return
  end

  local command = args[1]:lower()
  local config_update = {}

  if command == 'enable' then
    config_update.auto_refresh_enabled = true
    vim.notify('Anthropic OAuth auto-refresh enabled', vim.log.levels.INFO)
  elseif command == 'disable' then
    config_update.auto_refresh_enabled = false
    vim.notify('Anthropic OAuth auto-refresh disabled', vim.log.levels.INFO)
  elseif command == 'buffer' then
    local minutes = tonumber(args[2])
    if minutes and minutes >= 1 then
      config_update.refresh_buffer_minutes = minutes
      vim.notify(string.format('Anthropic OAuth refresh buffer set to %d minutes', minutes), vim.log.levels.INFO)
    else
      vim.notify('Invalid buffer time. Please provide a number >= 1', vim.log.levels.ERROR)
      return
    end
  elseif command == 'retries' then
    local retries = tonumber(args[2])
    if retries and retries >= 1 then
      config_update.max_retry_attempts = retries
      vim.notify(string.format('Anthropic OAuth max retry attempts set to %d', retries), vim.log.levels.INFO)
    else
      vim.notify('Invalid retry count. Please provide a number >= 1', vim.log.levels.ERROR)
      return
    end
  else
    vim.notify('Unknown command. Use: enable, disable, buffer <minutes>, or retries <count>', vim.log.levels.ERROR)
    return
  end

  configure_auto_refresh(config_update)
end, {
  nargs = '*',
  desc = 'Configure Anthropic OAuth auto-refresh settings',
})

-- Create adapter by extending base anthropic adapter
local adapter = vim.tbl_deep_extend('force', vim.deepcopy(anthropic), {
  name = 'anthropic_oauth',
  formatted_name = 'Anthropic (OAuth)',

  -- Role mapping (required for message processing)
  roles = {
    llm = 'assistant',
    user = 'user',
  },

  -- Expose configuration function for programmatic access
  configure_auto_refresh = configure_auto_refresh,

  env = {
    -- Get access token from OAuth flow for monthly plan users
    ---@return string|nil
    bearer_token = function()
      return get_access_token()
    end,
  },

  -- Override model schema with latest models
  schema = vim.tbl_deep_extend('force', anthropic.schema or {}, {
    model = {
      order = 1,
      mapping = 'parameters',
      type = 'enum',
      desc =
      'The model that will complete your prompt. See https://docs.anthropic.com/claude/docs/models-overview for additional details and options.',
      default = 'claude-sonnet-4-5-20250929',
      choices = {
        ['claude-opus-4-1-20250805'] = { opts = { can_reason = false, has_vision = true } },
        ['claude-opus-4-20250514'] = { opts = { can_reason = true, has_vision = true } },
        ['claude-sonnet-4-5-20250929'] = { opts = { can_reason = false, has_vision = true } },
        ['claude-3-7-sonnet-20250219'] = {
          opts = { can_reason = true, has_vision = true, has_token_efficient_tools = true },
        },
        ['claude-3-5-haiku-20241022'] = { opts = { has_vision = true } },
      },
    },
  }),
})

-- Override headers to use Bearer token for subscription usage
adapter.headers = {
  ['content-type'] = 'application/json',
  ['authorization'] = 'Bearer ${bearer_token}',
  ['anthropic-version'] = '2023-06-01',
  ['anthropic-beta'] =
  'claude-code-20250219,oauth-2025-04-20,interleaved-thinking-2025-05-14,fine-grained-tool-streaming-2025-05-14',
  ['x-request-id'] = function()
    return 'req_'
        .. string.format('%06x', math.random(0, 0xffffff))
        .. string.format('%06x', math.random(0, 0xffffff))
        .. string.format('%06x', math.random(0, 0xffffff))
  end,
}

-- Override handlers to add OAuth-specific functionality and Claude Code system message
adapter.handlers = vim.tbl_extend('force', anthropic.handlers, {
  -- Check for valid API key before starting request
  ---@param self table
  ---@return boolean
  setup = function(self)
    -- Get and validate access token
    local access_token = get_access_token()
    if not access_token then
      vim.notify('Anthropic access token not found. Run :AnthropicOAuthSetup to authenticate.', vim.log.levels.ERROR)
      return false
    end

    -- Same as current setup function but removing the additional headers being added
    if self.opts and self.opts.stream then
      self.parameters = self.parameters or {}
      self.parameters.stream = true
    end

    local model = self.schema and self.schema.model and self.schema.model.default
    local model_opts = self.schema
        and self.schema.model
        and self.schema.model.choices
        and self.schema.model.choices[model]
    if model_opts and model_opts.opts then
      self.opts = self.opts or {}
      self.opts = vim.tbl_deep_extend('force', self.opts, model_opts.opts)
      if not model_opts.opts.has_vision then
        self.opts.vision = false
      end
    end

    return true
  end,

  -- Format messages with Claude Code system message at the beginning (required for OAuth)
  ---@param self table
  ---@param messages table
  ---@return table
  form_messages = function(self, messages)
    local utils = require('codecompanion.utils.adapters')
    local tokens = require('codecompanion.utils.tokens')

    local has_tools = false

    ---@type table
    local system = vim
        .iter(messages)
        :filter(function(msg)
          return msg.role == 'system'
        end)
        :map(function(msg)
          return {
            type = 'text',
            text = msg.content,
            cache_control = nil,
          }
        end)
        :totable()

    -- Add the Claude Code system message at the beginning (required for OAuth to work properly)
    table.insert(system, 1, {
      type = 'text',
      text = "You are Claude Code, Anthropic's official CLI for Claude.",
    })

    ---@diagnostic disable-next-line: cast-local-type
    system = next(system) and system or nil

    ---@diagnostic disable-next-line: cast-local-type
    messages = vim
        .iter(messages)
        :filter(function(msg)
          return msg.role ~= 'system'
        end)
        :totable()

    messages = vim.tbl_map(function(message)
      if message.opts and message.opts.tag == 'image' and message.opts.mimetype then
        if self.opts and self.opts.vision then
          message.content = {
            {
              type = 'image',
              source = {
                type = 'base64',
                media_type = message.opts.mimetype,
                data = message.content,
              },
            },
          }
        else
          return nil
        end
      end

      -- Filter message to allowed fields
      for key, _ in pairs(message) do
        if not vim.tbl_contains({ 'content', 'role', 'reasoning', 'tool_calls' }, key) then
          message[key] = nil
        end
      end

      if message.role == (self.roles and self.roles.user) or message.role == (self.roles and self.roles.llm) then
        if message.role == (self.roles and self.roles.user) and message.content == '' then
          message.content = '<prompt></prompt>'
        end

        if type(message.content) == 'string' then
          message.content = {
            {
              type = 'text',
              text = message.content --[[@as string]],
            },
          }
        end
      end

      if message.tool_calls and vim.tbl_count(message.tool_calls) > 0 then
        has_tools = true
      end

      if message.role == 'tool' then
        message.role = self.roles and self.roles.user
      end

      if has_tools and message.role == (self.roles and self.roles.llm) and message.tool_calls then
        message.content = message.content or {}
        for _, call in ipairs(message.tool_calls) do
          table.insert(message.content --[[@as table]], {
            type = 'tool_use',
            id = call.id,
            name = call['function'].name,
            input = vim.json.decode(call['function'].arguments),
          })
        end
        message.tool_calls = nil
      end

      if message.reasoning and type(message.content) == 'table' then
        ---@diagnostic disable-next-line: param-type-mismatch
        table.insert(message.content, 1, {
          type = 'thinking',
          thinking = message.reasoning.content,
          signature = message.reasoning._data.signature,
        })
      end

      return message
    end, messages)

    messages = utils.merge_messages(messages)

    -- Handle tool consolidation
    if has_tools then
      for _, m in ipairs(messages) do
        if m.role == (self.roles and self.roles.user) and m.content and m.content ~= '' then
          if type(m.content) == 'table' and m.content.type then
            m.content = { m.content }
          end

          if type(m.content) == 'table' and vim.islist(m.content) then
            local consolidated = {}
            for _, block in ipairs(m.content) do
              if block.type == 'tool_result' then
                local prev = consolidated[#consolidated]
                if prev and prev.type == 'tool_result' and prev.tool_use_id == block.tool_use_id then
                  prev.content = prev.content .. block.content
                else
                  table.insert(consolidated, block)
                end
              else
                table.insert(consolidated, block)
              end
            end
            m.content = consolidated
          end
        end
      end
    end

    -- Handle caching
    local breakpoints_used = 0
    for i = #messages, 1, -1 do
      local msgs = messages[i]
      if msgs.role == (self.roles and self.roles.user) then
        for _, msg in ipairs(msgs.content) do
          if msg.type ~= 'text' or msg.text == '' then
            goto continue
          end
          if
              tokens.calculate(msg.text) >= ((self.opts and self.opts.cache_over) or 1024)
              and breakpoints_used < ((self.opts and self.opts.cache_breakpoints) or 2)
          then
            msg.cache_control = { type = 'ephemeral' }
            breakpoints_used = breakpoints_used + 1
          end
          ::continue::
        end
      end
    end
    if system and breakpoints_used < ((self.opts and self.opts.cache_breakpoints) or 2) then
      for _, prompt in ipairs(system) do
        if breakpoints_used < ((self.opts and self.opts.cache_breakpoints) or 2) then
          prompt.cache_control = { type = 'ephemeral' }
          breakpoints_used = breakpoints_used + 1
        end
      end
    end

    return { system = system, messages = messages }
  end,
})

return adapter
