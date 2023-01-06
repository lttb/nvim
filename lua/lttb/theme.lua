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

M.name = 'github_theme'
M.variant = 'light'
M.colorscheme = 'github_light'

M.current = M.pallettes[M.variant]

-- TODO: Add support for other themes
if utils.is_kitty() and M.colorscheme == 'github_light' then
  vim.cmd([[
    augroup kitty_mp
        autocmd!
        au VimLeave * :silent !kitty @ --to=$KITTY_LISTEN_ON set-colors --reset
        au VimEnter * :silent !kitty @ --to=$KITTY_LISTEN_ON set-colors "$HOME/.config/kitty/themes/github-light.conf"
    augroup END
  ]])
end

return M
