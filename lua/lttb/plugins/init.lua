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

return vim.list_extend(
  {
    'lewis6991/impatient.nvim',
    'nvim-lua/plenary.nvim',

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
    },
    { 'ggandor/leap-spooky.nvim', config = true },
    {
      'ggandor/flit.nvim',
      config = function()
        require('flit').setup({
          labeled_modes = 'nv',
        })
      end,
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
      'luukvbaal/statuscol.nvim',
      config = function()
        require('statuscol').setup({
          separator = ' ',
        })
      end,
      enabled = vim.fn.has('nvim-0.9.0') == 1,
    },
  }, {
    enabled = not utils.is_vscode(),
  })
)