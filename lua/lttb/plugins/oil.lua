local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require('oil').get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
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

return {
  {
    'stevearc/stickybuf.nvim',
    opts = {
      -- -- This function is run on BufEnter to determine pinning should be activated
      -- get_auto_pin = function(bufnr)
      --   local filetype = vim.bo[bufnr].filetype
      --
      --   if filetype == 'oil' then
      --     return true
      --   end
      --   -- You can return "bufnr", "buftype", "filetype", or a custom function to set how the window will be pinned.
      --   -- You can instead return an table that will be passed in as "opts" to `stickybuf.pin`.
      --   -- The function below encompasses the default logic. Inspect the source to see what it does.
      --   return require('stickybuf').should_auto_pin(bufnr)
      -- end,
    },
  },
  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    opts = {
      win_options = {
        winbar = '%!v:lua.get_oil_winbar()',
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
            prev_buf = buf

            return
          end

          if prev_buf == buf then
            return
          end

          if prev_buf == shown_buf then
            prev_buf = buf

            return
          end

          prev_buf = buf

          if shown_win ~= nil then
            if prev_win == shown_win then
              return
            end

            prev_win = win
            -- local buftype = vim.bo[buf].buftype
            -- local bufname = vim.api.nvim_buf_get_name(buf)
            -- print(is_file_buffer(buf), buftype, bufname)

            if not is_file_buffer(buf) then
              return
            end


            local oil = require('oil')
            local util = require('oil.util')
            local view = require('oil.view')

            local dir = oil.get_current_dir()
            local parent_url, basename = oil.get_url_for_path(dir)
            if basename then
              view.set_last_cursor(parent_url, basename)
            end


            is_pending = true
            vim.api.nvim_set_current_win(shown_win)
            vim.cmd.edit({ args = { util.escape_filename(parent_url) }, mods = { keepalt = true } })
            vim.api.nvim_set_option_value('buflisted', false, { buf = shown_buf })

            vim.api.nvim_set_current_win(win)
            is_pending = false

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

          local win = vim.api.nvim_get_current_win()
          vim.cmd('topleft 50vsp +Oil')
          vim.cmd('PinFiletype')
          shown_win = vim.api.nvim_get_current_win()
          shown_buf = vim.api.nvim_get_current_buf()
          vim.api.nvim_set_current_win(win)
        end,
      })
    end,
  },
}
