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

      overrides = function(c)
        local util = require('github-theme.util')

        return {
          IndentBlanklineChar = {
            fg = '#2f363d',
          },

          IndentBlanklineContextChar = {
            fg = '#383f46',
          },
        }
      end,
    },
  },
}

M.variant = 'light'
M.name = 'github'
M.colorscheme = 'github_light'

M.current = M.pallettes[M.variant]

return M