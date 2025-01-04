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

function oil_get_selected_file()
  local dir = require('oil').get_current_dir()
  local entry = require('oil').get_cursor_entry()
  local filepath = vim.fn.resolve(dir .. (entry and entry.name))

  return { filepath = filepath, entry = entry }
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

local commands = {
  system_open = function(filepath)
    vim.ui.open(filepath)
  end,
  copy_selector = function(filepath)
    local notify = require('notify')

    local modify = vim.fn.fnamemodify
    local filename = modify(filepath, ':t')

    local vals = {
      ['1.FILENAME'] = filename,
      ['2.DIRNAME'] = modify(filepath, ':h'),
      ['3.PATH (CWD)'] = modify(filepath, ':.'),
      ['4.PATH (HOME)'] = modify(filepath, ':~'),
      ['5.PATH (GLOBAL)'] = filepath,
      ['6.BASENAME'] = modify(filename, ':r'),
      ['7.EXTENSION'] = modify(filename, ':e'),
      ['8.URI'] = vim.uri_from_fname(filepath),
    }

    local options = vim.tbl_filter(function(val)
      return vals[val] ~= ''
    end, vim.tbl_keys(vals))
    if vim.tbl_isempty(options) then
      notify('No values to copy', vim.log.levels.WARN)
      return
    end
    table.sort(options)
    vim.ui.select(options, {
      prompt = 'Choose to copy to clipboard:',
      format_item = function(item)
        return ('%s: %s'):format(item:sub(3), vals[item])
      end,
    }, function(choice)
      local result = vals[choice]
      if result then
        notify(('Copied: `%s`'):format(result))
        vim.fn.setreg('+', result)
      end
    end)
  end,
  find_in_dir = function(type, filepath)
    require('telescope.builtin').find_files({
      cwd = type == 'directory' and filepath or vim.fn.fnamemodify(filepath, ':h'),
    })
  end,
}

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
        ['<S-O>'] = function()
          commands.system_open(oil_get_selected_file().filepath)
        end,
        ['<C-f>'] = function()
          local selected_file = oil_get_selected_file()
          commands.find_in_dir(selected_file.entry.type, selected_file.filepath)
        end,
        ['<S-y>'] = function()
          commands.copy_selector(oil_get_selected_file().filepath)
        end,
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

      -- local is_pending = false

      local pending_timer = nil
      local state = 'idle'

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        nested = true,
        callback = function(data)
          if state == 'initialising' then
            return
          end

          local filetype = vim.bo[data.buf].ft
          local buf = vim.api.nvim_get_current_buf()
          local win = vim.api.nvim_get_current_win()

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

            if pending_timer then
              pending_timer:stop()
            end

            pending_timer = vim.defer_fn(function()
              local shown_buf = vim.api.nvim_win_get_buf(shown_win)
              local current_buf_name = vim.api.nvim_buf_get_name(shown_buf)

              if not vim.startswith(current_buf_name, 'oil://') then
                return
              end

              local parent_url = oil_prepare_current_buf()

              local view = require('oil.view')

              if current_buf_name ~= parent_url then
                print(current_buf_name, parent_url)
                vim.api.nvim_buf_set_name(shown_buf, parent_url)
                view.render_buffer_async(shown_buf)
              end

              oil_maybe_set_cursor(shown_win)
            end, 0)

            return
          end

          if state == 'inited' then
            return
          end

          if not utils.should_open_sidebar(data) then
            return
          end

          state = 'initialising'

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

          state = 'inited'
        end,
      })
    end,
  },
}
