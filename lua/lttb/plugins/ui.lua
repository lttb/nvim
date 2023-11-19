-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    {
      'nvim-tree/nvim-web-devicons',
    },

    {
      'declancm/cinnamon.nvim',
      enabled = false,
      opts = {
        default_keymaps = true,
        extra_keymaps = true,
        extended_keymaps = true,

        hide_cursor = true,
        max_length = 50,
        scroll_limit = 150,
        always_scroll = true,
      },
    },

    -- { 'karb94/neoscroll.nvim', opts = {} },

    {
      'numToStr/FTerm.nvim',
      enabled = false,
      config = function()
        require('FTerm').setup({
          auto_close = true,
          border = { { ' ', 'WinSeparator' } },
          blend = 10,
          hl = 'NeoTreeNormal',
        })

        utils.keyplug('lttb-toggle-term', function()
          require('FTerm').toggle()
        end)
      end,
    },

    {
      'akinsho/toggleterm.nvim',
      keys = function()
        local Terminal = require('toggleterm.terminal').Terminal
        local term_options = {
          hidden = true,
          dir = 'git_dir',
          direction = 'float',
          highlights = {
            NormalFloat = {
              link = 'Normal',
            },
            FloatBorder = {
              link = 'FloatBorder',
            },
          },
          float_opts = {
            border = 'curved',
            winblend = 5,
          },
          winbar = {
            enabled = false,
            name_formatter = function(term) --  term: Terminal
              return term.name
            end,
          },
        }
        local term = Terminal:new(term_options)
        local lazygit = Terminal:new(vim.tbl_extend('keep', { cmd = 'lazygit' }, term_options))

        return {
          {
            '<D-j>',
            function()
              term:toggle()
            end,
            desc = 'Toggle Terminal',
            mode = { 'n', 't', 'i' },
          },
          {
            '<D-g>',
            function()
              lazygit:toggle()
            end,
            desc = 'Toggle lazy Git',
            mode = { 'n', 't', 'i' },
          },
        }
      end,
      config = true,
    },

    {
      'folke/noice.nvim',
      opts = {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },

          progress = {
            enabled = false,
          },

          signature = {
            enabled = false,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },

        messages = {
          view_error = 'mini',
          view_warn = 'mini',
          view = 'mini',
        },

        -- @see https://github.com/LazyVim/LazyVim/discussions/830
        routes = {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = { skip = true },
        },

        notify = {
          enabled = false,
        },
      },
      dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
      },
    },

    {
      'rcarriga/nvim-notify',
      init = function()
        vim.schedule(function()
          -- See https://github.com/neovim/nvim-lspconfig/issues/1931#issuecomment-1297599534
          -- An alternative solution: https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
          local banned_messages = { 'No information available' }
          vim.notify = function(msg, ...)
            for _, banned in ipairs(banned_messages) do
              if msg == banned then
                return
              end
            end
            return require('notify')(msg, ...)
          end
        end)
      end,
    },

    {
      'luukvbaal/statuscol.nvim',
      config = function()
        require('statuscol').setup({
          separator = ' ',
        })
      end,
      enabled = false,
      -- enabled = vim.fn.has('nvim-0.9.0') == 1,
    },

    {
      'utilyre/barbecue.nvim',
      name = 'barbecue',
      cond = not utils.is_neovide(),
      version = '*',
      dependencies = {
        'SmiteshP/nvim-navic',
        'nvim-tree/nvim-web-devicons', -- optional dependency
      },
      opts = {
        create_autocmd = false,

        show_modified = true,
      },
      init = function()
        -- Gain better performance when moving the cursor around
        -- @see https://github.com/utilyre/barbecue.nvim#-recipes
        vim.api.nvim_create_autocmd({
          'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
          'BufWinEnter',
          'CursorHold',
          'InsertLeave',

          -- include this if you have set `show_modified` to `true`
          'BufModifiedSet',
        }, {
          group = vim.api.nvim_create_augroup('barbecue.updater', {}),
          callback = function()
            require('barbecue.ui').update()
          end,
        })
      end,
    },

    {
      'Bekaboo/dropbar.nvim',
      enabled = false,
      -- optional, but required for fuzzy finder support
      dependencies = {
        'nvim-telescope/telescope-fzf-native.nvim',
      },
      opts = {},
    },

    {
      'romgrk/barbar.nvim',
      enabled = false,
      dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function()
        vim.g.barbar_auto_setup = false
      end,
      opts = {
        auto_hide = false,

        sidebar_filetypes = {
          ['neo-tree'] = true,
        },
      },
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },

    {
      'akinsho/bufferline.nvim',
      enabled = false,
      version = '*',
      opts = function()
        local bufferline = require('bufferline')

        return {
          options = {
            themable = true,

            offsets = {
              {
                filetype = 'neo-tree',
                text = 'File Explorer',
                highlight = 'Directory',
                separator = false, -- use a "true" to enable the default, or set your own character
              },
            },

            separator_style = 'thin',

            hover = {
              enabled = true,
              delay = 200,
              reveal = { 'close' },
            },

            diagnostics = 'nvim_lsp',
          },
        }
      end,
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },

    {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      opts = {
        indent = {
          char = utils.is_neovide() and '┊' or '┊',
        },

        scope = {
          show_start = false,
          show_end = false,

          -- @see https://github.com/lukas-reineke/indent-blankline.nvim/issues/632#issuecomment-1732366788
          include = {
            node_type = {
              lua = {
                'chunk',
                'do_statement',
                'while_statement',
                'repeat_statement',
                'if_statement',
                'for_statement',
                'function_declaration',
                'function_definition',
                'table_constructor',
                'assignment_statement',
              },
              typescript = {
                'statement_block',
                'function',
                'arrow_function',
                'function_declaration',
                'method_definition',
                'for_statement',
                'for_in_statement',
                'catch_clause',
                'object_pattern',
                'arguments',
                'switch_case',
                'switch_statement',
                'switch_default',
                'object',
                'object_type',
                'ternary_expression',
              },
            },
          },
        },
      },
      -- tag = 'v2.20.8',
      -- config = function()
      --   local indent_char = false and utils.is_neovide() and '·' or '┊'

      --   require('indent_blankline').setup({
      --     char = indent_char,
      --     context_char = indent_char,
      --     show_trailing_blankline_indent = false,
      --     show_current_context = true,
      --     show_first_indent_level = false,
      --   })
      -- end,
    },

    {
      'zbirenbaum/neodim',
      enabled = false,
      event = 'LspAttach',
      config = true,
      opts = {
        alpha = 0.3,
        -- blend_color = theme.variant == 'dark' and '#2a2c3c' or '#f0f0f0',
      },
    },

    {
      'lewis6991/hover.nvim',
      enabled = false,
      keys = function()
        local hover = require('hover')

        return {
          { 'K', hover.hover, desc = 'hover.nvim' },
          { 'gK', hover.hover_select, desc = 'hover.nvim select' },
        }
      end,
      config = function()
        require('hover').setup({
          init = function()
            require('hover.providers.lsp')
            require('hover.providers.gh')
            require('hover.providers.gh_user')
            require('hover.providers.jira')
            require('hover.providers.man')
            require('hover.providers.dictionary')
          end,
        })
      end,
    },

    {
      'mvllow/modes.nvim',
      event = 'BufEnter',
      opts = {
        line_opacity = 0.1,

        colors = {
          visual = '#BBBBBB',
        },
      },
    },

    {
      'folke/which-key.nvim',
      enabled = false,
      cmd = 'WhichKey',
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {},
      priority = 1,
    },

    {
      'folke/todo-comments.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = {
        signs = false,

        highlight = {
          keyword = 'fg',
        },
      },
    },

    {
      'folke/trouble.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      keys = {
        { '<S-D-m>', '<cmd>TroubleToggle<cr>', desc = 'Trouble: Toggle' },
        -- NOTE: support for neovide, @see https://github.com/neovide/neovide/issues/1237
        { '<S-M-m>', '<S-D-m>', remap = true },
      },
    },

    {
      'stevearc/dressing.nvim',
      opts = {
        select = {
          telescope = require('telescope.themes').get_cursor({}),
        },
      },
    },
  },
}
