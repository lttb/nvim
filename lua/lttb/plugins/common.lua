local utils = require('lttb.utils')

return {
  'nvim-lua/plenary.nvim',

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      search = {
        incremental = false,
        mode = 'fuzzy',
      },

      continue = true,

      remote_op = {
        restore = true,
        motion = true,
      },

      label = {
        uppercase = false,
      },

      modes = {
        char = {
          jump_labels = true,
        },
        search = {
          enabled = true,
        },
      },
    },
    keys = function()
      local flash = require('flash')

      return {
        { 's',     mode = { 'n', 'o' }, flash.jump,              desc = 'Flash' },
        { 'S',     mode = { 'n', 'o' }, flash.treesitter,        desc = 'Flash Treesitter' },
        { 'r',     mode = 'o',          flash.remote,            desc = 'Remote Flash' },
        { 'R',     mode = { 'o', 'x' }, flash.treesitter_search, desc = 'Treesitter Search' },
        { '<c-s>', mode = { 'c' },      flash.toggle,            desc = 'Toggle Flash Search' },
      }
    end,
  },

  {
    'ibhagwan/smartyank.nvim',
    event = 'LazyFile',
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

        -- validate_yank = false,

        -- validate_yank = function()
        --   return vim.v.operator == 'y'
        --       -- TODO: yanka needs to be improved
        --       or vim.v.operator == 'g@' -- support `yanka` operator
        --       or vim.v.operator == ':' -- support `yanka` visual
        -- end,
      })
    end,
  },

  {
    'gbprod/yanky.nvim',
    event = 'LazyFile',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
      -- { 'p',  '<Plug>(YankyPutAfter)',   mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
      -- { 'P',  '<Plug>(YankyPutBefore)',  mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
      -- { 'gp', '<Plug>(YankyGPutAfter)',  mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
      -- { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
    },
  },

  {
    'chrisgrieser/nvim-spider',
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
    -- extended treesitter objects
    'chrisgrieser/nvim-various-textobjs',
    event = 'LazyFile',
    opts = { keymaps = { useDefaultKeymaps = true, disabledKeymaps = { 'gc' } } },
  },

}
