local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  -- it should be "nested" not to show the number column
  -- @see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1106
  nested = true,
  callback = function(data)
    if not utils.should_open_sidebar(data) then
      return
    end

    -- open the tree but don't focus it
    vim.cmd('Neotree show')
  end,
})

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = false,
    keys = {
      { '<D-b>', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Sidebar' } },
      { '<D-e>', '<cmd>Neotree reveal<cr>', { desc = 'Focus Sidebar' } },
    },
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    opts = {
      window = {
        width = utils.is_neovide() and 50 or '25%',

        min_width = 40,
      },

      filesystem = {
        filtered_items = {
          visible = true,
        },

        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        group_empty_dirs = false,

        use_libuv_file_watcher = true,
      },

      default_component_configs = {
        name = {
          highlight_opened_files = true,
        },
      },
    },
  },
}
