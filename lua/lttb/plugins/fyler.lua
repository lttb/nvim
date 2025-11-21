local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'A7Lavinraj/fyler.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    branch = 'stable',
    opts = {
      views = {
        finder = {
          close_on_select = false,
          confirm_simple = true,
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

          local curr_winid = vim.api.nvim_get_current_win()

          -- Open Fyler with optional settings
          require('fyler').open({
            kind = 'split_left_most',
          })

          vim.schedule(function()
            vim.api.nvim_set_current_win(curr_winid)
          end)
        end,
      })
    end,
  },
}
