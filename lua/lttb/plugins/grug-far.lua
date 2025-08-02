local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
    event = 'LazyFile',
    keys = {
      {
        '<leader>gf',
        function()
          require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })
        end,
      },
    },
  },
}
