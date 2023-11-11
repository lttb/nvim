local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local theme = require('lttb.theme')

return {
  -- lush is used for color calculations
  { 'rktjmp/lush.nvim',          priority = 1000 },

  {
    'projekt0n/github-nvim-theme',
    lazy = true,     -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup({
        groups = {
          github_light = {
            CursorLine = {
              bg = '#f6f8fa',
            },
          },
        },

        options = {
          styles = {
            keywords = 'NONE',
          },

          transparent = false,

          darken = {
            floats = true,
            sidebars = {
              enable = true,
              -- list = { 'qf', 'vista_kind', 'terminal', 'packer', 'cmdline' },
            },
          },
        },
      })
    end,
  },

  { 'eihigh/vim-aomi-grayscale', lazy = true },

  {
    'sainnhe/edge',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.g.edge_style = 'neon'
      vim.g.edge_transparent_background = 0
      vim.g.edge_diagnostic_text_highlight = 1
      vim.g.edge_diagnostic_line_highlight = 1
      vim.g.edge_better_performance = 1
    end,
  },

  {
    'catppuccin/nvim',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
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

  {
    'rmehri01/onenord.nvim',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
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

  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      styles = {
        keywords = { italic = false },
      },
    },
  },

  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      compile = true,
      keywordStyle = { italic = false },
      dimInactive = true,
    },
  },

  {
    'mcchrish/zenbones.nvim',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    dependencies = { 'rktjmp/lush.nvim' },
  },

  {
    'wadackel/vim-dogrun',
    lazy = true,
    priority = 1000,
  },

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    priority = 1000,
  },

  { 'ronisbr/nano-theme.nvim', lazy = true, priority = 1000 },

  { 'kvrohit/rasmus.nvim',     lazy = true, priority = 1000 },
}
