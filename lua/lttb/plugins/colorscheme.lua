local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  -- lush is used for color calculations
  { 'rktjmp/lush.nvim', lazy = true },
  {
    'rktjmp/shipwright.nvim',
    lazy = true,
    cmd = { 'Shipwright' },
  },

  {
    'mcchrish/zenbones.nvim',
    lazy = true,
    dependencies = { 'rktjmp/lush.nvim' },
  },

  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = true,
  },

  {
    'lttb/morningstar.nvim',
    lazy = true,
  },
}
