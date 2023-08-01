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
    -- 'lewis6991/impatient.nvim',
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
              max_phase_one_targets = 2,

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
      enabled = false,
    },
    { 'ggandor/leap-spooky.nvim', config = true, enabled = false },
    {
      'ggandor/flit.nvim',
      config = function()
        require('flit').setup({
          labeled_modes = 'nv',
        })
      end,
      -- NOTE: use hop
      enabled = false,
    },

    {
      'phaazon/hop.nvim',
      branch = 'v2',
      config = function()
        local hop = require('hop')

        hop.setup({
          jump_on_sole_occurrence = true,
        })

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

      enabled = false,
    },

    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      ---@type Flash.Config
      opts = {},
      keys = {
        {
          's',
          mode = { 'n', 'x', 'o' },
          function()
            -- default options: exact mode, multi window, all directions, with a backdrop
            require('flash').jump()
          end,
          desc = 'Flash',
        },
        {
          'S',
          mode = { 'n', 'o', 'x' },
          function()
            require('flash').treesitter()
          end,
          desc = 'Flash Treesitter',
        },
        {
          'r',
          mode = 'o',
          function()
            require('flash').remote()
          end,
          desc = 'Remote Flash',
        },
      },
    },

    {
      'gbprod/substitute.nvim',
      config = function()
        local substitute = require('substitute')
        substitute.setup({})

        utils.keyplug('lttb-substiture-operator', substitute.operator)
        utils.keyplug('lttb-substiture-line', substitute.line)
        utils.keyplug('lttb-substiture-eol', substitute.eol)
        utils.keyplug('lttb-substiture-visual', substitute.visual)
      end,
    },

    {
      'chaoren/vim-wordmotion',
      init = function()
        vim.g.wordmotion_prefix = ';'
      end,
    },

    {
      'echasnovski/mini.nvim',
      config = function()
        require('mini.ai').setup({
          search_method = 'cover_or_nearest',
        })

        require('mini.align').setup({})

        if utils.is_vscode() then
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

    {
      'mvllow/modes.nvim',
      tag = 'v0.2.1',
      opts = {
        line_opacity = 0.05,
      },
      -- NOTE: something's wrong with the colours
      enabled = false,
    },
  },
  map_plugins_config({
    { 'tpope/vim-sleuth' },

    {
      'nvim-tree/nvim-web-devicons',
    },

    { 'JoosepAlviste/nvim-ts-context-commentstring' },
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup({
          ignore = '^$',
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        })
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
          max_length = 50,
          scroll_limit = 150,
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
          border = { { ' ', 'WinSeparator' } },
          blend = 10,
          hl = 'NeoTreeNormal',
        })

        utils.keyplug('lttb-toggle-term', function()
          require('FTerm').toggle()
        end)
      end,
      enabled = false,
    },

    {
      'akinsho/toggleterm.nvim',
      config = function()
        require('toggleterm').setup()

        local Terminal = require('toggleterm.terminal').Terminal
        local term = Terminal:new({
          hidden = true,
          dir = 'git_dir',
          direction = 'float',
          float_opts = {
            border = { { ' ', 'WinSeparator' } },
            winblend = 5,
          },
        })

        utils.keyplug('lttb-toggle-term', function()
          term:toggle()
        end)
      end,
    },

    {
      'folke/noice.nvim',
      opts = {
        presets = {
          command_palette = true, -- position the cmdline and popupmenu together
        },
      },
      dependencies = {
        'MunifTanjim/nui.nvim',
      },
      enabled = not utils.is_goneovim(),
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
      'gaoDean/autolist.nvim',
      ft = {
        'markdown',
        'text',
        'tex',
        'plaintex',
      },
      config = function()
        local autolist = require('autolist')
        autolist.setup()
        autolist.create_mapping_hook('i', '<CR>', autolist.new)
        autolist.create_mapping_hook('i', '<Tab>', autolist.indent)
        autolist.create_mapping_hook('i', '<S-Tab>', autolist.indent, '<C-D>')
        autolist.create_mapping_hook('n', 'o', autolist.new)
        autolist.create_mapping_hook('n', 'O', autolist.new_before)
        autolist.create_mapping_hook('n', '>>', autolist.indent)
        autolist.create_mapping_hook('n', '<<', autolist.indent)
        autolist.create_mapping_hook('n', '<C-r>', autolist.force_recalculate)
        autolist.create_mapping_hook('n', '<leader>x', autolist.invert_entry, '')
        vim.api.nvim_create_autocmd('TextChanged', {
          pattern = '*',
          callback = function()
            vim.cmd.normal({
              autolist.force_recalculate(nil, nil),
              bang = false,
            })
          end,
        })
      end,
      -- feels quite buggy, disable for now
      enabled = false,
    },
  }, {
    enabled = not utils.is_vscode(),
  })
)
