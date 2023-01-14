local utils = require('lttb.utils')

return {
  {
    'projekt0n/github-nvim-theme',
    config = function()
      local theme = require('lttb.theme')

      require('github-theme').setup({
        theme_style = theme.current.github_theme.theme_style,
        colors = theme.current.github_theme.colors,
        overrides = theme.current.github_theme.overrides,

        -- dark_float = not utils.is_neovide(),
        -- dark_sidebar = not utils.is_neovide(),
        dark_float = true,
        dark_sidebar = false,
        keyword_style = 'NONE',
        transparent = false,
        sidebars = { 'qf', 'vista_kind', 'terminal', 'packer', 'cmdline' },
      })
    end,
    enabled = not utils.is_vscode(),
  },

  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
    config = {
      line_opacity = 0.05,
    },
  },
}
