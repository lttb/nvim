local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function init()
  vim.cmd.colorscheme(utils.theme)
end

return {
  {
    'lttb/morningstar.nvim',
    lazy = false,
    priority = 1000,
    init = init,
  },

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
    init = function()
      vim.g.zenwritten = { transparent_background = not utils.is_neovide(), italic_strings = false }
    end,
  },

  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = true,
  },

  {
    'idr4n/github-monochrome.nvim',
    lazy = true,
    opts = {
      on_highlights = function(hl, c, s)
        hl.Substitute = { fg = c.highlight, bg = c.red }
      end,
    },
  },

  {
    'ronisbr/nano-theme.nvim',
    lazy = true,
  },

  {
    'RRethy/base16-nvim',
    lazy = true,
  },

  {
    'rjshkhr/shadow.nvim',
    lazy = true,
  },

  {
    'alexxGmZ/e-ink.nvim',
    lazy = true,
  },

  {
    'webhooked/kanso.nvim',
    lazy = true,
    opts = {
      keywordStyle = { italic = false },
    },
  },
}
