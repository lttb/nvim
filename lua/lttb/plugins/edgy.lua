local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = 'screen'
    end,
    opts = {
      animate = {
        enabled = false,
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = 'Neo-Tree',
          pinned = true,
          open = function()
            vim.cmd('Neotree show')
          end,
          collapsed = false,
          ft = 'neo-tree',
          filter = function(buf)
            return vim.b[buf].neo_tree_source == 'filesystem'
          end,
          size = { width = 0.25 },
        },
      },
    },
  },
}
