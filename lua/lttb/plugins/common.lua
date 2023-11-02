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
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      -- stylua: ignore start
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      -- stylua: ignore end
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
}
