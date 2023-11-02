local utils = require('lttb.utils')
local theme = require('lttb.theme')

if utils.is_vscode() then
  return {}
end

return {
  {
    'mvllow/modes.nvim',
    opts = {
      line_opacity = 0.05,
    },
    enabled = false,
  },

  {
    'lewis6991/hover.nvim',
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

      utils.keyplug('lttb-lsp-hover', require('hover').hover, {
        desc = 'hover.nvim',
      })
      utils.keyplug('lttb-lsp-hover-select', require('hover').hover_select, {
        desc = 'hover.nvim (select)',
      })
    end,
  },

  {
    'zbirenbaum/neodim',
    event = 'LspAttach',
    config = true,
    opts = {
      alpha = 0.5,
      -- blend_color = theme.variant == 'dark' and '#2a2c3c' or '#f0f0f0',
    },
    enabled = false,
  },

  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = function()
      vim.g.code_action_menu_show_diff = true
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'VimEnter',
    config = true,
  },

  {
    'windwp/nvim-autopairs',
    event = 'VimEnter',
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local npairs = require('nvim-autopairs')

      npairs.setup({
        check_ts = true,
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6',
    config = true,
    -- TODO: check the config - so far it's not really convinient to insert/delete pairs to wrap expressions
    enabled = false,
  },

  {
    'axelvc/template-string.nvim',
    event = 'VimEnter',
    config = true,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'VimEnter',
    config = function()
      vim.defer_fn(function()
        require('copilot').setup({
          panel = {
            auto_refresh = true,
          },

          suggestion = {
            auto_trigger = true,
            accept = false,
          },

          filetypes = {
            ['*'] = true,
          },

          -- NOTE: it has to be node v16
          -- @see https://github.com/zbirenbaum/copilot.lua/issues/69
          -- Check later if it works with v18
          copilot_node_command = 'node',
        })
      end, 100)
    end,
    enabled = false,
    -- NOTE: error "client quit with exit code 0 and signal"
    -- TODO: investigate and raise an issue
    -- enabled = not utils.is_neovide(),
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = false and utils.is_neovide() and '·' or '┊',
      },

      scope = {
        show_start = false,
        show_end = false,

        -- @see https://github.com/lukas-reineke/indent-blankline.nvim/issues/632#issuecomment-1732366788
        -- include = {
        --   node_type = {
        --     lua = {
        --       'chunk',
        --       'do_statement',
        --       'while_statement',
        --       'repeat_statement',
        --       'if_statement',
        --       'for_statement',
        --       'function_declaration',
        --       'function_definition',
        --       'table_constructor',
        --       'assignment_statement',
        --     },
        --     typescript = {
        --       'statement_block',
        --       'function',
        --       'arrow_function',
        --       'function_declaration',
        --       'method_definition',
        --       'for_statement',
        --       'for_in_statement',
        --       'catch_clause',
        --       'object_pattern',
        --       'arguments',
        --       'switch_case',
        --       'switch_statement',
        --       'switch_default',
        --       'object',
        --       'object_type',
        --       'ternary_expression',
        --     },
        --   },
        -- },
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
    -- TODO: review this plugin, not sure I'll keep it
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = { 'json' },
    config = function()
      local package_info = require('package-info')
      local gs = package.loaded.gitsigns

      package_info.setup({
        autostart = false,
        hide_up_to_date = true,
      })

      vim.api.nvim_create_user_command('NpmInstall', function()
        package_info.install()
      end, {})

      vim.api.nvim_create_user_command('NpmDelete', function()
        package_info.delete()
      end, {})

      vim.api.nvim_create_user_command('NpmToggle', function()
        gs.toggle_current_line_blame()
        package_info.toggle()
      end, {})

      vim.api.nvim_create_user_command('NpmUpdate', function()
        package_info.update()
      end, {})

      vim.api.nvim_create_user_command('NpmVersion', function()
        package_info.change_version()
      end, {})
    end,
  },

  {
    'windwp/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local spectre = require('spectre')

      spectre.setup({
        live_update = true,
        is_insert_mode = true,
      })

      utils.keyplug('lttb-spectre', spectre.open, {
        desc = 'spectre.nvim',
      })

      utils.keyplug('lttb-spectre-search-in-file', spectre.open_file_search, {
        desc = 'spectre.nvim | search in file',
      })

      utils.keyplug('lttb-spectre-search-word', function()
        spectre.open_visual({ select_word = true })
      end, {
        desc = 'spectre.nvim | search word',
      })

      utils.keyplug('lttb-spectre-open-visual', function()
        spectre.open_visual({ select_word = true })
      end, {
        desc = 'spectre.nvim | open visual',
      })
    end,
  },

  {
    'smjonas/live-command.nvim',
    config = function()
      require('live-command').setup({
        commands = {
          Norm = { cmd = 'norm' },
        },
      })
    end,
  },

  { 'NvChad/nvim-colorizer.lua', config = true },

  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    opts = {
      show_modified = true,
    },
  },

  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      auto_hide = false,

      highlight_alternate = true,
      highlight_inactive_file_icons = true,

      icons = {
        separator = { left = '', right = '' },
      },

      sidebar_filetypes = {
        ['neo-tree'] = true,
      },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released

    enabled = false,
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

        highlights = {
          fill = {
            bg = {
              attribute = 'bg',
              highlight = 'Normal',
            },
          },
        },
      }
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    -- enabled = false,
  },

  -- {
  --   'coffebar/neovim-project',
  --   opts = {
  --     projects = { -- define project roots
  --       '~/dev/work/*',
  --       '~/.config/*',
  --     },
  --   },
  --   init = function()
  --     -- enable saving the state of plugins in the session
  --     vim.opt.sessionoptions:append('globals') -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  --   end,
  --   dependencies = {
  --     { 'nvim-lua/plenary.nvim' },
  --     { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
  --     { 'Shatur/neovim-session-manager' },
  --   },
  --   lazy = false,
  --   priority = 100,
  -- },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
}
