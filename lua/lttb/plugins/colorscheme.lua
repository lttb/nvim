local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local theme = require('lttb.theme')

return {
  -- lush is used for color calculations
  { 'rktjmp/lush.nvim', lazy = true },

  {
    'mcchrish/zenbones.nvim',
    lazy = true,
    dependencies = { 'rktjmp/lush.nvim' },
    init = function()
      vim.g.zenbones_lightness = 'bright'
    end,
  },
}
