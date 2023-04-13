local utils = require('lttb.utils')
local theme = require('lttb.theme')

local themes = {
  github = {
    'projekt0n/github-nvim-theme',
    -- tag = 'v0.0.7',
    lazy = true,
    config = function()
      require('github-theme').setup({
        colors = theme.current.github.colors,
        overrides = theme.current.github.overrides,
        styles = {
          keywords = 'NONE',
        },

        -- dark_float = not utils.is_neovide(),
        -- dark_sidebar = not utils.is_neovide(),
        dark_float = true,
        dark_sidebar = false,
        transparent = false,
        sidebars = { 'qf', 'vista_kind', 'terminal', 'packer', 'cmdline' },
      })
    end,
  },

  edge = {
    'sainnhe/edge',
    lazy = true,
    config = function()
      vim.g.edge_style = 'neon'
      vim.g.edge_transparent_background = 0
      vim.g.edge_diagnostic_text_highlight = 1
      vim.g.edge_diagnostic_line_highlight = 1
      vim.g.edge_better_performance = 1
    end,
  },

  catppuccin = {
    'catppuccin/nvim',
    lazy = true,
    as = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        -- transparent_background = true,
        term_colors = true,

        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },

        styles = {
          conditionals = {},
        },

        custom_highlights = function(c)
          local cursorword_bg = theme.colorscheme == 'catppuccin-latte' and c.crust or c.surface1

          return {
            ['@tag.attribute.tsx'] = {
              fg = c.lavender,
              style = {},
            },
            MiniCursorword = {
              bg = cursorword_bg,
            },
            MiniCursorwordCurrent = {
              bg = cursorword_bg,
            },

            -- LspDiagnosticsUnderlineError = {
            --   link = 'DiagnosticVirtualTextError',
            -- },
            -- LspDiagnosticsUnderlineWarning = {
            --   link = 'DiagnosticVirtualTextError',
            -- },
            -- LspDiagnosticsUnderlineInformation = {
            --   link = 'DiagnosticVirtualTextError',
            -- },
            -- LspDiagnosticsUnderlineHint = {
            --   link = 'DiagnosticVirtualTextError',
            -- },
          }
        end,

        integrations = {
          leap = true,
          hop = true,
          mason = true,
          noice = true,
          treesitter_context = true,
          treesitter = true,
          neotree = true,

          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },

          native_lsp = {
            enabled = true,
          },
        },
      })
    end,
  },

  onenord = {
    'rmehri01/onenord.nvim',
    lazy = true,
    opts = {
      borders = false,
      fade_nc = false,
      disable = {
        -- background = true,
      },
      inverse = {
        match_paren = true,
      },
    },
  },

  tokyonight = {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
      styles = {
        keywords = { italic = false },
      },
    },
  },
}

if utils.is_vscode() then
  return {}
end

return themes[theme.name]
