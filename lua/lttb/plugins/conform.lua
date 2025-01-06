local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local js_formatter = function(bufnr)
  local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })

  local is_biome = false
  for _, client in pairs(lsp_clients) do
    if client.name == 'biome' then
      is_biome = true
      break
    end
  end

  if is_biome then
    return { 'biome' }
  end

  -- use global "prettierd" instead of Mason?
  return { lsp_format = 'first', 'prettierd' }
end

return {
  {
    -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    init = function()
      vim.api.nvim_create_user_command('Format', function()
        require('conform').format({ async = true })
      end, {})
    end,
    opts = {
      notify_on_error = false,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function(bufnr)
        local timeout_ms = 500
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }

        if disable_filetypes[vim.bo[bufnr].filetype] then
          return {
            timeout_ms = timeout_ms,
            lsp_format = 'never',
          }
        end

        return {
          timeout_ms = 500,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua', lsp_format = 'last' },
        zsh = { 'shfmt' },
        sh = { 'shfmt' },
        typescript = js_formatter,
        typescriptreact = js_formatter,
        javascript = js_formatter,
        javascriptreact = js_formatter,
        json = js_formatter,
        jsonc = js_formatter,
        yaml = { 'prettier' },
        ['markdown'] = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
        ['toml'] = { 'taplo' },
      },
    },
  },
}
