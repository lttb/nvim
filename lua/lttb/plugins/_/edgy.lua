local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'folke/edgy.nvim',
    -- event = 'VeryLazy',
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = 'screen'

      local is_shown = false

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        -- it should be "nested" not to show the number column
        -- @see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1106
        -- nested = true,
        callback = function(data)
          if not utils.should_open_sidebar(data) or is_shown then
            return
          end

          -- open the tree but don't focus it
          is_shown = true
          -- vim.cmd('Oil')
        end,
      })
    end,
    opts = {
      animate = {
        enabled = false,
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = 'Oil',
          pinned = true,
          open = function()
            -- vim.cmd('Oil')
          end,
          collapsed = false,
          ft = 'oil',
          size = { width = 0.25 },
        },
      },
    },
  },
}
