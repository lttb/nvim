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

        color_overrides = {
          latte = {
            rosewater = '#cc7983',
            flamingo = '#bb5d60',
            pink = '#d54597',
            mauve = '#a65fd5',
            red = '#b7242f',
            maroon = '#db3e68',
            peach = '#e46f2a',
            yellow = '#bc8705',
            green = '#1a8e32',
            teal = '#00a390',
            sky = '#089ec0',
            sapphire = '#0ea0a0',
            blue = '#017bca',
            lavender = '#8584f7',
            text = '#444444',
            subtext1 = '#555555',
            subtext0 = '#666666',
            overlay2 = '#777777',
            overlay1 = '#888888',
            overlay0 = '#999999',
            surface2 = '#aaaaaa',
            surface1 = '#bbbbbb',
            surface0 = '#cccccc',
            base = '#ffffff',
            mantle = '#eeeeee',
            crust = '#dddddd',
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
    config = function()
      vim.g.zenbones_lightness = 'bright'
    end,
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
    opts = {
      dark_variant = 'moon',
      extend_background_behind_borders = true,
      styles = {
        italic = false,
      },
      highlight_groups = {
        -- Normal = { bg = '#FFFFFF' },
        -- CursorLine = {}
      },

      before_highlight = function(group, highlight, palette)
        if theme.variant ~= 'light' then
          return
        end

        if highlight.bg == palette.base then
          highlight.bg = '#ffffff'
        elseif highlight.bg == palette.overlay then
          highlight.bg = '#f6f8fa'
        end
      end,
    },
  },

  { 'ronisbr/nano-theme.nvim', lazy = true, priority = 1000 },

  { 'kvrohit/rasmus.nvim',     lazy = true, priority = 1000 },

  {
    'RRethy/nvim-base16',
    lazy = true,
    priority = 1000,
  },

  { 'rktjmp/shipwright.nvim' },

  {
    'diegoulloao/neofusion.nvim',
    priority = 1000,
    config = true,
    opts = {
      terminal_colors = true,
    },
  },

  { 'slugbyte/lackluster.nvim', lazy = true, priority = 1000 },

  { 'datsfilipe/vesper.nvim',   lazy = true, priority = 1000 },

  {
    'sho-87/kanagawa-paper.nvim',
    lazy = true,
    priority = 1000,
    opts = {},
  },

  {
    'navarasu/onedark.nvim',
    lazy = true,
    priority = 1000,
    opts = {},
  },

  {
    'olimorris/onedarkpro.nvim',
    lazy = true,
    priority = 1000,
  },

  {
    'aliqyan-21/darkvoid.nvim',
    lazy = true,
    priority = 1000,
  },
}
