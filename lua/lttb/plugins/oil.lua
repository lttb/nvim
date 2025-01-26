local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'stevearc/stickybuf.nvim',
    lazy = true,
    config = function()
      require('stickybuf').setup({
        get_auto_pin = function()
          return false
        end,
      })

      local util = require('stickybuf.util')

      -- don't ignore empty buffers
      -- @see https://github.com/stevearc/stickybuf.nvim/issues/30
      ---@diagnostic disable-next-line: duplicate-set-field
      util.is_empty_buffer = function()
        return false
      end
    end,
  },

  -- TODO: support sidebar toggling
  -- TODO: check edgy.nvim again, there were perf issues
  {
    'stevearc/oil.nvim',
    lazy = false,
    cmd = 'Oil',
    opts = {
      default_file_explorer = false,

      skip_confirm_for_simple_edits = true,

      -- NOTE: with the latest changes, there is an error
      -- Could not find oil adapter for scheme '/..file.lua://'
      -- [oil] could not find adapter for buffer '/..file.lua://'
      watch_for_changes = true,

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
        ['<C-h>'] = false,
        ['f'] = function()
          require('mini.files').open(oil_get_selected_file().directory)
        end,
        ['<S-O>'] = function()
          require('lttb.utils.fs').system_open(oil_get_selected_file().filepath)
        end,
        ['<C-f>'] = function()
          local selected_file = oil_get_selected_file()
          require('lttb.utils.fs').find_in_dir(selected_file.entry.type, selected_file.filepath)
        end,
        ['<S-D-f>'] = function()
          local selected_file = oil_get_selected_file()
          require('lttb.utils.fs').grep_in_dir(selected_file.entry.type, selected_file.filepath)
        end,
        ['<C-y>'] = function()
          require('lttb.utils.fs').copy_selector(oil_get_selected_file().filepath)
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          vim.opt_local.number = false
          -- Mark the window as special
          vim.w.oil_window = true
          -- Set window options to prevent most plugins from targeting it
          vim.opt_local.winfixwidth = true
          vim.opt_local.equalalways = true
          vim.opt_local.buflisted = false
        end,
      })

      -- NOTE: investigate the issue with adapters on watched files with oil opened
      local config = require('oil.config')
      local _get_adapter_by_scheme = config.get_adapter_by_scheme
      config.get_adapter_by_scheme = function(scheme)
        if not scheme then
          return nil
        end

        if not vim.endswith(scheme, '://') then
          return require('oil.adapters.files')
        end

        return _get_adapter_by_scheme(scheme)
      end

      local sb = require('lttb.utils.oil_sidebar')

      sb.setup()
    end,
  },
}
