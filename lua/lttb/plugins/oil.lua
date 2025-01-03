local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function is_file_buffer(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Exclude oil.nvim buffers (bufname starts with "oil://")
  if bufname:match('^oil://') then
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

  local bufname = vim.api.nvim_buf_get_name(0)
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

-- Based on oil.nvim maybe_set_cursor
-- @see https://github.com/stevearc/oil.nvim/blob/ba858b662599eab8ef1cba9ab745afded99cb180/lua/oil/view.lua#L40-L60
---Set the cursor to the last_cursor_entry if one exists
local function oil_maybe_set_cursor(bufid, winid)
  bufid = bufid or 0
  winid = winid or 0

  local oil = require('oil')
  local view = require('oil.view')
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

return {
  {
    'stevearc/stickybuf.nvim',
    event = 'VeryLazy',
    init = function()
      local util = require('stickybuf.util')

      -- don't ignore empty buffers
      -- @see https://github.com/stevearc/stickybuf.nvim/issues/30
      util.is_empty_buffer = function()
        return false
      end
    end,
    opts = {},
  },
  {
    'stevearc/oil.nvim',
    event = 'VeryLazy',
    cmd = 'Oil',
    opts = {
      win_options = {
        winbar = '%!v:lua.oil_render_winbar()',
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      keymaps = {
        ['<C-r>'] = 'actions.refresh',
        ['<C-l>'] = false,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          -- Mark the window as special
          vim.w.oil_window = true
          -- Set window options to prevent most plugins from targeting it
          vim.opt_local.winfixwidth = true
          vim.opt_local.buflisted = false
        end,
      })

      local shown_win = nil

      local prev_win = nil

      local is_pending = false

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        nested = true,
        callback = function(data)
          local filetype = vim.bo[data.buf].ft
          local buf = vim.api.nvim_get_current_buf()
          local win = vim.api.nvim_get_current_win()

          if is_pending then
            return
          end

          if filetype == 'oil' then
            prev_win = win

            return
          end

          if shown_win ~= nil then
            if prev_win == shown_win then
              prev_win = win

              return
            end

            prev_win = win

            if not is_file_buffer(buf) then
              return
            end

            is_pending = true

            local view = require('oil.view')

            local parent_url = oil_prepare_current_buf()

            local shown_buf = vim.api.nvim_win_get_buf(shown_win)
            local current_buf_name = vim.api.nvim_buf_get_name(shown_buf)

            if current_buf_name ~= parent_url then
              vim.api.nvim_buf_set_name(shown_buf, parent_url)
              view.render_buffer_async(shown_buf)
            end

            oil_maybe_set_cursor(shown_buf, shown_win)

            is_pending = false

            return
          end

          if not utils.should_open_sidebar(data) then
            return
          end

          is_pending = true

          local view = require('oil.view')

          local shown_buf = vim.api.nvim_create_buf(false, false)

          shown_win = vim.api.nvim_open_win(shown_buf, false, {
            split = 'left',
            width = 50,
            focusable = true,
            -- style = 'minimal',
          })

          local parent_url = oil_prepare_current_buf()

          vim.api.nvim_buf_set_name(shown_buf, parent_url)

          view.initialize(shown_buf)

          require('stickybuf').pin(shown_win, {
            allow = function(bufnr)
              local ft = vim.bo[bufnr].ft

              return bufnr == shown_buf or ft == 'oil'
            end,
          })

          is_pending = false
        end,
      })
    end,
  },
}
