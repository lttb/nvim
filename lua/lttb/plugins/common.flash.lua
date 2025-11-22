return {
  {
    'folke/flash.nvim',
    vscode = true,
    ---@type Flash.Config
    opts = {
      search = {
        incremental = false,
        mode = 'exact',
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
}
