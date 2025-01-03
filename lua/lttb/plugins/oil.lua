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

function _G.get_oil_winbar()
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
    init = function()
      local util = require('stickybuf.util')

      -- @see https://github.com/stevearc/stickybuf.nvim/issues/30
      util.is_empty_buffer = function()
        return false
      end
    end,
    opts = {
      -- This function is run on BufEnter to determine pinning should be activated
      get_auto_pin = function(bufnr)
        local filetype = vim.bo[bufnr].filetype

        -- if filetype == 'oil' then
        --   return true
        -- end
        -- You can return "bufnr", "buftype", "filetype", or a custom function to set how the window will be pinned.
        -- You can instead return an table that will be passed in as "opts" to `stickybuf.pin`.
        -- The function below encompasses the default logic. Inspect the source to see what it does.
        return require('stickybuf').should_auto_pin(bufnr)
      end,
    },
  },
  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    opts = {
      win_options = {
        winbar = '%!v:lua.get_oil_winbar()',
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
      local shown_buf = nil
      local is_shown = false

      local prev_buf = nil
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

            local oil = require('oil')
            local view = require('oil.view')

            local bufname = vim.api.nvim_buf_get_name(0)
            local dir = vim.fn.fnamemodify(bufname, ':h') -- Get the buffer's directory (omit filename)

            is_pending = true
            -- vim.api.nvim_set_current_win(shown_win)

            local parent_url = oil.get_url_for_path(dir)
            local basename = vim.fn.fnamemodify(bufname, ':t')

            if basename then
              view.set_last_cursor(parent_url, basename)
            end

            local current_buf_name = vim.api.nvim_buf_get_name(shown_buf)

            if current_buf_name ~= parent_url then
              vim.api.nvim_buf_set_name(shown_buf, parent_url)
              view.render_buffer_async(shown_buf)
              -- oil.load_oil_buffer(shown_buf, shown_win)
              -- vim.cmd.edit({ args = { util.escape_filename(parent_url) } })
              -- local oil_buf = vim.api.nvim_get_current_buf()
              -- vim.api.nvim_set_option_value('buflisted', false, { buf = oil_buf })
            end

            oil_maybe_set_cursor(shown_buf, shown_win)

            -- vim.api.nvim_set_current_win(win)
            is_pending = false

            -- vim.defer_fn(function()
            -- end, 0)

            -- vim.cmd.edit({ args = { util.escape_filename(parent_url) }, mods = { keepalt = true } })

            -- vim.api.nvim_set_current_win(win)

            -- print(parent_url, basename)

            -- view.initialize(shown_buf)

            -- local win = vim.api.nvim_get_current_win()
            -- vim.api.nvim_set_current_win(shown_win)
            -- require('oil').open()
            -- vim.api.nvim_set_current_win(win)
            -- require('oil.view').render_buffer_async(shown_buf)
            -- require('oil.view').initialize(shown_buf)

            return
          end

          if is_shown then
            return
          end

          if not utils.should_open_sidebar(data) then
            return
          end

          is_shown = true

          -- TODO: make it async and without window switch, using oil.initialize
          is_pending = true
          local win = vim.api.nvim_get_current_win()
          vim.cmd('topleft 50vsp +Oil')
          require('stickybuf').pin()
          -- vim.cmd('PinFiletype')
          shown_win = vim.api.nvim_get_current_win()
          shown_buf = vim.api.nvim_get_current_buf()
          vim.api.nvim_set_current_win(win)
          is_pending = false
        end,
      })
    end,
  },
}
