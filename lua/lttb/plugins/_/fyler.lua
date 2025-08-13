local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'A7Lavinraj/fyler.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    branch = 'main',
    opts = {
      views = {
        explorer = {
          auto_confirm_simple_edits = true,
          close_on_select = false,

          win = {
            win_opts = {
              number = false,
              relativenumber = false,
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

          -- open the tree but don't focus it
          is_shown = true
          vim.cmd('Fyler kind=split_left_most')
        end,
      })
    end,
  },
}
