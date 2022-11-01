local M = {}

M.pallettes = {
  light = {
    github_theme = {
      theme_style = 'light',

      colors = {
        bg_highlight = '#f6f8fa',
      },

      overrides = function(c)
        local util = require('github-theme.util')

        return {
          IndentBlanklineChar = {
            fg = '#e6eaec',
          },

          IndentBlanklineContextChar = {
            fg = '#c5c5c5',
          },
        }
      end,
    },
  },

  dark = {
    github_theme = {
      theme_style = 'dark',

      colors = {},
    },
  },
}

M.variant = 'light'
M.name = 'github'

M.current = M.pallettes[M.variant]

return M
