local utils = require('lttb.utils')

local M = {}

local function is_file_buffer(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if buftype == 'oil' then
    return true
  end

  if bufname:find('^term://') ~= nil then
    return false
  end

  if bufname:match('/scratch/') then
    return false
  end

  if buftype:find('^snacks_') then
    return false
  end

  -- Regular file buffers have an empty buftype and a non-empty bufname
  return buftype == '' and bufname ~= ''
end

local prev_winbar = ''
function _G.oil_render_winbar()
  local buf = vim.api.nvim_get_current_buf()

  -- Avoid updating the winbar for floating windows or specific filetypes
  if not is_file_buffer(buf) then
    return prev_winbar -- Return an empty string to avoid setting the winbar
  end

  local bufname = vim.api.nvim_buf_get_name(0):gsub('oil://', '')
  local bufdir = vim.fn.fnamemodify(bufname, ':h') -- Get the buffer's directory (omit filename)
  prev_winbar = vim.fn.fnamemodify(bufdir, ':.')   -- Make it relative to CWD

  return prev_winbar
end

function oil_prepare_current_buf()
  local oil = require('oil')
  local view = require('oil.view')
  local bufname = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(bufname, ':h') -- Get the buffer's directory (omit filename)

  local parent_url = oil.get_url_for_path(dir)
  local basename = vim.fn.fnamemodify(bufname, ':t')

  if basename then
    view.set_last_cursor(parent_url, basename)
  end

  return parent_url, basename
end

function oil_get_selected_file()
  local dir = require('oil').get_current_dir()
  local entry = require('oil').get_cursor_entry()
  local filepath = vim.fn.resolve(dir .. (entry and entry.name))

  return { filepath = filepath, directory = dir, entry = entry }
end

-- Based on oil.nvim maybe_set_cursor
-- @see https://github.com/stevearc/oil.nvim/blob/ba858b662599eab8ef1cba9ab745afded99cb180/lua/oil/view.lua#L40-L60
---Set the cursor to the last_cursor_entry if one exists
local function oil_maybe_set_cursor(winid)
  winid = winid or 0

  local oil = require('oil')
  local view = require('oil.view')
  local bufid = vim.api.nvim_win_get_buf(winid)
  local bufname = vim.api.nvim_buf_get_name(bufid)
  local entry_name = view.get_last_cursor(bufname)
  if not entry_name then
    return
  end
  local line_count = vim.api.nvim_buf_line_count(bufid)
  for lnum = 1, line_count do
    local entry = oil.get_entry_on_line(bufid, lnum)
    if entry and entry.name == entry_name then
      local line = vim.api.nvim_buf_get_lines(bufid, lnum - 1, lnum, true)[1]
      local id_str = line:match('^/(%d+)')
      local col = line:find(entry_name, 1, true) or (id_str:len() + 1)
      vim.api.nvim_win_set_cursor(winid, { lnum, col - 1 })
      view.set_last_cursor(bufname, nil)
      break
    end
  end
end

-- @see https://github.com/nvim-neo-tree/neo-tree.nvim/blob/2a0b2c5d394a280cee9444c9894582ac53098604/lua/neo-tree/utils/init.lua
local function find_buffer_by_name(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == name then
      return buf
    end
  end
  return -1
end

function M.setup()
  local shown_win = nil

  local prev_win = nil

  -- local is_pending = false

  local pending_timer = nil
  local state = 'idle'

  local function open_sidebar()
    state = 'initialising'

    local view = require('oil.view')

    local winwin = require('lttb.utils.windows')

    winwin.setup()

    local current_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, false)

    -- vim.defer_fn(function ()
    --
    -- end, 0)

    shown_win = winwin.open_win(buf, false, {
      focusable = false,
      split = 'left',
      fixed = true,
    }, {
      sync = true,
      width = 0.25,
      min_width = 30,
    })

    local parent_url = oil_prepare_current_buf()

    local existing_buf = find_buffer_by_name(parent_url)

    if existing_buf == -1 then
      vim.api.nvim_buf_set_name(buf, parent_url)
      view.initialize(buf)
    else
      vim.api.nvim_win_set_buf(shown_win, existing_buf)
    end

    require('stickybuf').pin(shown_win, {
      allow = function(bufnr)
        local ft = vim.bo[bufnr].ft
        local shown_buf = vim.api.nvim_win_get_buf(shown_win)

        -- print('pin', bufnr, buf, shown_buf)

        return bufnr ~= shown_buf or ft == 'oil'
      end,
    })

    vim.defer_fn(function()
      -- force to focus on the original win
      vim.api.nvim_set_current_win(current_win)
    end, 0)

    vim.api.nvim_create_autocmd({ 'WinEnter' }, {
      nested = true,
      callback = function(data)
        local win = vim.api.nvim_get_current_win()
        if win ~= shown_win then
          return
        end

        local width_expected = winwin.get_win_width(win)
        local width = vim.api.nvim_win_get_width(win)

        if width_expected ~= width then
          local empty_buf = vim.api.nvim_create_buf(false, true)
          local total_width = vim.o.columns

          -- print('initial', shown_win)

          local empty_buf_pattern = 'oil_scratch_buf'

          vim.api.nvim_create_autocmd('FileType', {
            pattern = empty_buf_pattern,
            once = true,
            callback = function()
              vim.opt_local.number = false
              vim.opt_local.colorcolumn = ''
            end,
          })

          vim.api.nvim_create_autocmd('WinResized', {
            once = true,
            callback = function()
              vim.api.nvim_open_win(empty_buf, false, {
                split = 'right',
                width = total_width - width_expected - 1, -- Adjust split width (50% of current width)
                focusable = false,
              })

              vim.api.nvim_set_option_value('filetype', empty_buf_pattern, { buf = empty_buf })

              -- vim.api.nvim_buf_set_option(empty_buf, 'number', false)
              -- vim.api.nvim_buf_set_option(empty_buf, 'relativenumber', false)

              -- vim.api.nvim_win_set_config(0, {
              --   width = width_expected,
              --   split = 'left',
              --   vertical = true,
              -- })
            end,
          })

          -- vim.cmd('e')
          -- winwin.resize_synced_windows()
          -- width_expected = vim.api.nvim_win_get_width(win)
        end

        -- local win_amount = #vim.api.nvim_tabpage_list_wins(0)
        --
        -- print('hey', win_amount)
        --
        -- if win_amount > 1 then
        --   return
        -- end
        --
        -- print('alone')
      end,
    })

    state = 'inited'
  end

  function close_sidebar()
    if not shown_win or not vim.api.nvim_win_is_valid(shown_win) then
      return false
    end

    vim.api.nvim_win_close(shown_win, true)
    shown_win = nil

    return true
  end

  function toggle_sidebar()
    if not close_sidebar() then
      open_sidebar()
    end
  end

  vim.keymap.set({ 'n', 'i', 'x' }, '<D-b>', toggle_sidebar, { silent = true })

  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    nested = true,
    callback = function(data)
      -- print(string.format('event fired: %s', vim.inspect(data)))

      if state == 'initialising' then
        return
      end

      local filetype = vim.bo[data.buf].ft
      local buf = data.buf
      local win = vim.api.nvim_get_current_win()

      if filetype == 'oil' then
        return
      end

      if shown_win ~= nil then
        if not is_file_buffer(buf) then
          return
        end

        if not vim.api.nvim_win_is_valid(shown_win) then
          return
        end

        local shown_buf = vim.api.nvim_win_get_buf(shown_win)
        local current_buf_name = vim.api.nvim_buf_get_name(shown_buf)

        if not vim.startswith(current_buf_name, 'oil://') then
          return
        end

        local parent_url = oil_prepare_current_buf()

        local view = require('oil.view')

        if current_buf_name ~= parent_url then
          -- TODO: think about more efficient way
          local existing_buf = find_buffer_by_name(parent_url)

          if existing_buf == -1 then
            vim.api.nvim_buf_set_name(shown_buf, parent_url)
            view.render_buffer_async(shown_buf)
          else
            vim.api.nvim_win_set_buf(shown_win, existing_buf)
          end
        end

        oil_maybe_set_cursor(shown_win)

        return
      end

      if state == 'inited' then
        return
      end

      if not utils.should_open_sidebar(data) then
        return
      end

      open_sidebar()
    end,
  })
end

return M
