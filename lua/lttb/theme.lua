local utils = require('lttb.utils')
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

          TSVariable = {
            fg = c.black,
          },

          TSParameter = {
            fg = c.orange,
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
            fg = '#454d56',
          },

          TSVariable = {
            fg = c.bright_white,
          },
        }
      end,
    },
  },
}

M.variant = 'dark'
M.name = 'edge'
M.colorscheme = 'edge'

M.current = M.pallettes[M.variant]

return M
