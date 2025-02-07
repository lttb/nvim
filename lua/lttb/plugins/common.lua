local utils = require('lttb.utils')

return {
  'nvim-lua/plenary.nvim',

  {
    'folke/flash.nvim',
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
      local res = nil
      local function get()
        if res then
          return res
        end

        res = { flash = require('flash') }
        return res
      end

      return {
        {
          's',
          mode = { 'n', 'o' },
          function()
            get().flash.jump()
          end,
          desc = 'Flash',
        },
        {
          'S',
          mode = { 'n', 'o' },
          function()
            get().flash.treesitter()
          end,
          desc = 'Flash Treesitter',
        },
        {
          'r',
          mode = 'o',
          function()
            get().flash.remote()
          end,
          desc = 'Remote Flash',
        },
        {
          'R',
          mode = { 'o', 'x' },
          function()
            get().flash.treesitter_search()
          end,
          desc = 'Treesitter Search',
        },
        {
          '<c-s>',
          mode = { 'c' },
          function()
            get().flash.toggle()
          end,
          desc = 'Toggle Flash Search',
        },
      }
    end,
  },

  {
    'ibhagwan/smartyank.nvim',
    event = 'VeryLazy',
    opts = {
      highlight = {
        enabled = true,         -- highlight yanked text
        higroup = 'CursorLine', -- highlight group of yanked text
        timeout = 200,          -- timeout for clearing the highlight
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
    },
  },

  {
    'lttb/yanka.nvim',
    opts = {},
    keys = {
      -- { 'y',     '<Plug>(YankyYank)', mode = { 'x' } },
      -- { '<D-c>', '<Plug>(YankyYank)', mode = { 'x' } },
      { 'y',     'my<cmd>normal! y<cr>`y<cmd>redraw!<cr>', mode = { 'x' } },
      { '<D-c>', 'my<cmd>normal! y<cr>`y<cmd>redraw!<cr>', mode = { 'x' } },
      { '<D-x>', '"+d',                                    mode = { 'x' } },
      { '<D-x>', '"+dd',                                   mode = { 'n' } },
      { '<D-c>', 'yy',                                     mode = { 'n' } },
      {
        '<D-v>',
        '<cmd>lua require("yanka").put_with_autoindent()<CR>',
        mode = { 'i', 'n', 't', 'x' },
        noremap = true,
        silent = true,
      },
      { '<D-v>', '<C-r>+', mode = { 'c' } },
    },
  },

  {
    enabled = false,
    'gbprod/yanky.nvim',
    event = 'VeryLazy',
    config = function()
      -- vim.keymap.set('v', 'y', function()
      --   return 'my"' .. vim.v.register .. 'y`y'
      -- end, { expr = true })

      -- vim.opt.clipboard = 'unnamedplus'

      require('yanky').setup({
        highlight = {
          on_yank = false,
          timer = 200,
        },
      })

      vim.api.nvim_set_hl(0, 'YankyYanked', { link = 'CursorLine' })
      vim.api.nvim_set_hl(0, 'YankyPut', { link = 'CursorLine' })
    end,
    keys = {
      -- { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
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
    opts = { keymaps = { useDefaults = true, disabledDefaults = { 'gc' } } },
  },

  {
    'chrishrb/gx.nvim',
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    cmd = { 'Browse' },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = true,
    submodules = false,
  },
}
