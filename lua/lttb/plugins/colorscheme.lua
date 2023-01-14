local theme = require('lttb.theme')

local themes = {
  github_theme = {
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
  },

  edge = {
    'sainnhe/edge',
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
    as = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        -- transparent_background = true,
        term_colors = true,
        dim_inactive = {
          enabled = true,
          shade = 'dark',
          percentage = 0.15,
        },

        no_italic = true,

        custom_highlights = function(c)
          return {
            MiniCursorword = { bg = c.surface1 },
            MiniCursorwordCurrent = { bg = c.surface1 },

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
          -- leap = true,
          -- hop = true,
          -- mason = true,
          -- noice = true,
          -- treesitter_context = true,
          -- treesitter = true,

          -- indent_blankline = {
          --   enabled = true,
          --   colored_indent_levels = false,
          -- },

          native_lsp = {
            enabled = true,
            -- virtual_text = {
            --   errors = { 'italic' },
            --   hints = { 'italic' },
            --   warnings = { 'italic' },
            --   information = { 'italic' },
            -- },
            -- underlines = {
            --   errors = { bg = '#EEBEBE' },
            --   hints = { bg = '#626880' },
            --   warnings = { bg = '#EF9F76' },
            --   information = { bg = '#EA999C' },
            -- },
          },
        },
      })
    end,
  },

  onenord = {
    'rmehri01/onenord.nvim',
    config = {
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
    config = {
      styles = {
        keywords = { italic = false },
      },
    },
  },
}

return themes[theme.name]
