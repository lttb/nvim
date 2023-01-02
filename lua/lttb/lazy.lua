-- vim:fileencoding=utf-8:foldmethod=marker

-- {{{ Bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
-- }}}

local utils = require('lttb.utils')

local function map_plugins_config(tbl, c)
  local t = {}
  for k, v in pairs(tbl) do
    t[k] = vim.tbl_extend('keep', v, c)
    if t[k].enabled then
      t[k].enabled = t[k].enabled and c.enabled
    end
  end
  return t
end

require('lazy').setup(vim.list_extend(
  {
    'lewis6991/impatient.nvim',
    'nvim-lua/plenary.nvim',

    -- {{{ Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require('lttb.plugins.treesitter').setup({})
      end,
    },
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'RRethy/nvim-treesitter-textsubjects',
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require('treesitter-context').setup()

        local theme = require('lttb.theme')

        if theme.colorscheme == 'github_light' then
          -- NOTE: for some reason nvim_set_hl didn't override
          -- vim.api.nvim_set_hl(0, 'TreesitterContext', {
          --   link = 'CursorLineFold',
          --   default = false,
          --   nocombine = true,
          -- })
          vim.cmd('hi! link TreesitterContext CursorLineFold')
        end
      end,
    },
    -- }}}

    {
      'kylechui/nvim-surround',
      config = true,
    },

    {
      'ggandor/leap.nvim',
      config = function()
        local leap = require('leap')

        leap.set_default_keymaps()

        vim.keymap.set('', 's', function()
          leap.leap({
            target_windows = { vim.fn.win_getid() },

            opts = {
              equivalence_classes = {
                '\t\r\n',
                ')]}>',
                '([{<',
                { '"', "'", '`' },
              },
            },
          })
        end, {
          silent = true,
        })
      end,
      dependencies = {
        'ggandor/leap-spooky.nvim',
        'ggandor/flit.nvim',
      },
    },

    {
      'gbprod/substitute.nvim',
      config = function()
        local substitute = require('substitute')
        substitute.setup({})

        local utils = require('lttb.utils')

        utils.keyplug('lttb-substiture-operator', substitute.operator)
        utils.keyplug('lttb-substiture-line', substitute.line)
        utils.keyplug('lttb-substiture-eol', substitute.eol)
        utils.keyplug('lttb-substiture-visual', substitute.visual)
      end,
    },

    {
      'phaazon/hop.nvim',
      branch = 'v2',
      config = function()
        local hop = require('hop')

        hop.setup({
          jump_on_sole_occurrence = true,
        })

        local utils = require('lttb.utils')

        utils.keyplug('lttb-hop-on', function()
          hop.hint_char1({
            current_line_only = false,
          })
        end)

        utils.keyplug('lttb-hop-pre', function()
          hop.hint_char1({
            current_line_only = false,
            hint_offset = -1,
          })
        end)
      end,
    },

    {
      'echasnovski/mini.nvim',
      config = function()
        require('mini.ai').setup({
          search_method = 'cover_or_nearest',
        })

        require('mini.align').setup({})

        if require('lttb.utils').is_vscode() then
          return
        end

        require('mini.cursorword').setup({})

        local MiniMap = require('mini.map')

        MiniMap.setup({
          integrations = {
            MiniMap.gen_integration.builtin_search(),
            MiniMap.gen_integration.gitsigns(),
          },
          symbols = {
            encode = MiniMap.gen_encode_symbols.dot('3x2'),
            scroll_line = '▶ ',
            scroll_view = '┃ ',
          },

          window = {
            show_integration_count = false,
          },
        })

        vim.api.nvim_create_autocmd('BufEnter', {
          callback = function()
            MiniMap.open({})
          end,
        })
      end,
    },

    {
      'ibhagwan/smartyank.nvim',
      config = function()
        require('smartyank').setup({
          highlight = {
            enabled = true, -- highlight yanked text
            higroup = 'Search', -- highlight group of yanked text
            timeout = 200, -- timeout for clearing the highlight
          },
          clipboard = {
            enabled = true,
          },
          tmux = {
            enabled = true,
            -- remove `-w` to disable copy to host client's clipboard
            cmd = { 'tmux', 'set-buffer', '-w' },
          },
          osc52 = {
            enabled = true,
            ssh_only = true, -- false to OSC52 yank also in local sessions
            silent = false, -- true to disable the "n chars copied" echo
            echo_hl = 'Directory', -- highlight group of the OSC52 echo message
          },
        })
      end,
    },
  },
  map_plugins_config({
    { 'tpope/vim-sleuth' },

    {
      'kyazdani42/nvim-web-devicons',
    },

    { 'JoosepAlviste/nvim-ts-context-commentstring' },

    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup({
          ignore = '^$',
          pre_hook = require(
            'ts_context_commentstring.integrations.comment_nvim'
          ).create_pre_hook(),
        })
      end,
    },

    -- {{{ Git
    {
      'tpope/vim-fugitive',
      event = 'VimEnter',
    },

    {
      'tpope/vim-rhubarb',
      event = 'VimEnter',
    },

    {
      'lewis6991/gitsigns.nvim',
      event = 'VimEnter',
      config = true,
    },

    -- }}}

    -- LSP and CMP {{{
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'saadparwaiz1/cmp_luasnip' },
    },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',

        'onsails/lspkind.nvim',
        'L3MON4D3/LuaSnip',

        'lukas-reineke/cmp-rg',
      },
      config = function()
        require('lttb.plugins.lsp')
      end,
    },

    {
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
        require('lttb.plugins.null-ls')
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
              keymap = {
                accept = '<C-l>',
              },
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
    },

    {
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        local utils = require('lttb.utils')
        local indent_char = false and utils.is_neovide() and '·' or '┊'

        require('indent_blankline').setup({
          char = indent_char,
          context_char = indent_char,
          show_trailing_blankline_indent = false,
          show_current_context = true,
          show_first_indent_level = false,
        })
      end,
    },

    -- }}}

    {
      'kyazdani42/nvim-tree.lua',
      config = function()
        require('lttb.plugins.nvim-tree')
      end,
    },

    {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lttb.plugins.lualine')
      end,
    },

    { 'arkav/lualine-lsp-progress' },

    {
      'projekt0n/github-nvim-theme',
      config = function()
        local theme = require('lttb.theme')
        local utils = require('lttb.utils')

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

        vim.cmd.colorscheme(theme.colorscheme)
      end,
    },

    {
      'declancm/cinnamon.nvim',
      config = function()
        require('cinnamon').setup({
          default_keymaps = true,
          extra_keymaps = true,
          extended_keymaps = true,

          hide_cursor = true,
          max_length = 150,
          always_scroll = true,
        })
      end,
      enabled = not utils.is_neovide(),
    },

    {
      'numToStr/FTerm.nvim',
      config = function()
        require('FTerm').setup({
          auto_close = true,
        })

        local utils = require('lttb.utils')

        utils.keyplug('lttb-toggle-term', function()
          require('FTerm').toggle()
        end)
      end,
    },

    {
      'folke/noice.nvim',
      config = function()
        require('noice').setup({})
      end,
      dependencies = {
        'MunifTanjim/nui.nvim',
      },
    },

    {
      'nvim-telescope/telescope.nvim',
      config = function()
        require('lttb.plugins.telescope')
      end,
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- @see https://github.com/nvim-telescope/telescope-fzf-native.nvim#cmake-windows-linux-macos
      -- run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      build = 'make',
      config = function()
        require('telescope').load_extension('fzf')
      end,
    },
  }, {
    enabled = not utils.is_vscode(),
  })
))

if utils.is_vscode() then
  require('lttb.vscode')

  return
end

if utils.is_neovide() then
  require('lttb.neovide')

  return
end
