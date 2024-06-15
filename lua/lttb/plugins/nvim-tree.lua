local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-tree.lua',
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = function()
      local nvim_tree_api = require('nvim-tree.api')

      return {
        {
          '<D-e>',
          '<cmd>NvimTreeFindFile<cr>',
          desc = 'Focus Sidebar',
        },
        {
          '<D-b>',
          function()
            nvim_tree_api.tree.toggle({
              focus = false,
            })
          end,
          desc = 'Toggle Sidebar',
        },
      }
    end,
    init = function()
      if utils.is_neovide() then
        return
      end

      vim.api.nvim_create_autocmd({ 'VimEnter' }, {
        -- it should be "nested" not to show the number column
        -- @see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1106
        nested = true,
        callback = function(data)
          if not utils.should_open_sidebar(data) then
            return
          end

          vim.schedule(function()
            require('nvim-tree.api').tree.toggle({
              focus = false,
            })
          end)
        end,
      })
    end,
    opts = {
      prefer_startup_root = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      reload_on_bufenter = true,
      update_focused_file = {
        enable = true,
      },

      view = {
        width = {
          min = '25%',
          max = '25%',
        },
      },

      renderer = {
        icons = {
          git_placement = 'after',
        },
      },

      filters = {
        git_ignored = false,
      },

      notify = {
        threshold = vim.log.levels.ERROR,
      },
    },
  },
}
