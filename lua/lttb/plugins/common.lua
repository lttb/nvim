local utils = require('lttb.utils')

return {
  'nvim-lua/plenary.nvim',

  { 'kylechui/nvim-surround', opts = { keymaps = { visual = '<C-S>' } } },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      search = {
        incremental = true,
        mode = 'fuzzy',
      },

      continue = true,

      remote_op = {
        restore = true,
        motion = true,
      },

      modes = {
        search = {
          enabled = true,
        },
      },
    },
    keys = function()
      local flash = require('flash')

      return {
        { 's',     mode = { 'n', 'x', 'o' }, flash.jump,              desc = 'Flash' },
        { 'S',     mode = { 'n', 'x', 'o' }, flash.treesitter,        desc = 'Flash Treesitter' },
        { 'r',     mode = 'o',               flash.remote,            desc = 'Remote Flash' },
        { 'R',     mode = { 'o', 'x' },      flash.treesitter_search, desc = 'Treesitter Search' },
        { '<c-s>', mode = { 'c' },           flash.toggle,            desc = 'Toggle Flash Search' },
      }
    end,
  },

  {
    enabled = false,
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
    enabled = false,
    init = function()
      vim.g.wordmotion_prefix = ';'
    end,
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup({ search_method = 'cover_or_nearest' })

      require('mini.align').setup({})

      if utils.is_vscode() then
        return
      end

      require('mini.bufremove').setup({})

      require('mini.cursorword').setup({})

      local MiniMap = require('mini.map')

      MiniMap.setup({
        integrations = { MiniMap.gen_integration.builtin_search(), MiniMap.gen_integration.gitsigns() },
        symbols = { encode = MiniMap.gen_encode_symbols.dot('3x2'), scroll_line = '▶ ', scroll_view = '┃ ' },

        window = { show_integration_count = false },
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          if vim.bo.filetype == 'toggleterm' then
            MiniMap.close()
            return
          end

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
          enabled = true,     -- highlight yanked text
          higroup = 'Search', -- highlight group of yanked text
          timeout = 200,      -- timeout for clearing the highlight
        },
        clipboard = { enabled = true },
        tmux = {
          enabled = true,
          -- remove `-w` to disable copy to host client's clipboard
          cmd = { 'tmux', 'set-buffer', '-w' },
        },
        osc52 = {
          enabled = true,
          ssh_only = true,       -- false to OSC52 yank also in local sessions
          silent = false,        -- true to disable the "n chars copied" echo
          echo_hl = 'Directory', -- highlight group of the OSC52 echo message
        },
      })
    end,
  },

  {
    'chrisgrieser/nvim-spider',
    opts = {},
    keys = {
      {
        'e',
        "<cmd>lua require('spider').motion('e')<CR>",
        desc = 'Spider-e',
        mode = { 'n', 'o', 'x' },
      },
      {
        'w',
        "<cmd>lua require('spider').motion('w')<CR>",
        desc = 'Spider-w',
        mode = { 'n', 'o', 'x' },
      },
      {
        'b',
        "<cmd>lua require('spider').motion('b')<CR>",
        desc = 'Spider-b',
        mode = { 'n', 'o', 'x' },
      },
      {
        'ge',
        "<cmd>lua require('spider').motion('ge')<CR>",
        desc = 'Spider-ge',
        mode = { 'n', 'o', 'x' },
      },
    },
  },

  {
    'chrisgrieser/nvim-various-textobjs',
    lazy = false,
    opts = { useDefaultKeymaps = true },
  },
}
