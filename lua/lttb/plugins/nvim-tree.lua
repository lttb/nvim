local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvim-tree/nvim-tree.lua',

    keys = {
      {
        '<D-b>',
        function()
          local api = require('nvim-tree.api')

          api.tree.toggle({ focus = false, find_file = true })
        end,
        desc = 'Toggle Sidebar',
        mode = { 'n', 'i', 'x' },
      },
    },

    opts = {
      view = {
        width = {
          min = 200,
          max = '30%',
        },
      },

      update_focused_file = {
        enable = true,
      },

      renderer = {
        highlight_git = 'none',

        icons = {
          git_placement = 'signcolumn',

          glyphs = {
            git = {
              unstaged = '┆',
              staged = '┃',
              unmerged = '┃',
              renamed = '┃',
              untracked = '┆',
              deleted = '▁',
              ignored = '┆',
            },
          },
        },
      },
    },

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

          local api = require('nvim-tree.api')

          is_shown = true
          -- open the tree but don't focus it
          api.tree.find_file({ focus = false, open = true })
        end,
      })
    end,
  },
}
