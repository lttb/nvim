local utils = require('lttb.utils')

return {
  'nvim-lua/plenary.nvim',

  {
    'kylechui/nvim-surround',
    config = {
      keymaps = {
        visual = '<C-S>',
      },
    },
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

      -- require('mini.tabline').setup({})

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
}
