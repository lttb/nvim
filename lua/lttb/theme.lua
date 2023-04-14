local utils = require('lttb.utils')
local M = {}

M.pallettes = {
  light = {
    github = {
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
            fg = c.fg,
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

          ['@method'] = {
            fg = c.syntax.func,
          },

          ['@method.call'] = {
            fg = c.syntax.func,
          },

          ['@keyword.operator'] = {
            fg = c.syntax.keyword,
          },
        }
      end,
    },
  },

  dark = {
    github = {
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
M.name = 'github'
M.colorscheme = 'github_light'

M.current = M.pallettes[M.variant]

return M
