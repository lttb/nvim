local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = { 'Neotree' },
    keys = {
      { '<D-b>', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Sidebar' } },
      -- { '<D-e>', '<cmd>Neotree reveal<cr>', { desc = 'Focus Sidebar' } },
    },
    branch = 'v3.x',
    init = function()
      local is_shown = false

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        -- it should be "nested" not to show the number column
        -- @see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1106
        nested = true,
        callback = function(data)
          if not utils.should_open_sidebar(data) or is_shown then
            return
          end

          -- open the tree but don't focus it
          is_shown = true
          vim.cmd('Neotree show')
        end,
      })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      window = {
        min_width = 50,
        width = '25%',

        mappings = {
          ['<space>'] = false, -- disable space until we figure out which-key disabling
          s = false,
          ['[b'] = 'prev_source',
          [']b'] = 'next_source',
          ['<C-f>'] = 'find_in_dir',
          O = 'system_open',
          ['<C-y>'] = 'copy_selector',
          o = 'open',
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ['<C-j>'] = 'move_cursor_down',
          ['<C-k>'] = 'move_cursor_up',
        },
      },

      enable_diagnostics = false,
      enable_git_status = false,

      -- enable_diagnostics = not utils.is_dotfiles(),
      -- enable_git_status = not utils.is_dotfiles(),

      filesystem = {
        filtered_items = {
          visible = true,
        },

        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = false,

        -- use_libuv_file_watcher = not utils.is_dotfiles(),
      },

      default_component_configs = {
        name = {
          highlight_opened_files = true,
        },
      },

      -- @see https://github.com/AstroNvim/AstroNvim/blob/main/lua/plugins/neo-tree.lua
      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()

          require('lttb.utils.fs').system_open(filepath)
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()

          require('lttb.utils.fs').copy_selector(filepath)
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()

          require('lttb.utils.fs').find_in_dir(node.type, filepath)
        end,
      },
    },
  },
}
