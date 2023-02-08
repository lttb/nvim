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

        local orange = '#e36108'

        return {
          IndentBlanklineChar = {
            fg = '#e6eaec',
          },

          IndentBlanklineContextChar = {
            fg = '#c5c5c5',
          },

          ['@variable'] = {
            fg = c.black,
          },

          ['@property'] = {
            fg = c.white,
          },

          ['@parameter'] = {
            fg = orange,
          },

          ['@type'] = {
            fg = c.magenta,
          },

          ['@type.builtin'] = {
            fg = c.blue,
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

M.variant = 'light'
M.name = 'github_theme'
M.colorscheme = 'github_light'

M.current = M.pallettes[M.variant]

return M
