local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      dashboard = { enabled = true },
      scratch = { enabled = true },
      indent = {
        enabled = true,

        animate = {
          enabled = false,
        },

        indent = {
          char = '┊',
        },
      },
      -- input = { enabled = true },
      -- notifier = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 50 },
          easing = 'linear',
        },
      },
      scope = { enabled = true },
      -- words = {},
    },
    config = function(_, opts)
      -- @see https://github.com/LazyVim/LazyVim/blob/d0c366e4d861b848bdc710696d5311dca2c6d540/lua/lazyvim/plugins/init.lua#L21-L29
      local notify = vim.notify
      require('snacks').setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      vim.notify = notify
    end,
    keys = function()
      return {
        {
          '<leader><leader>',
          function()
            Snacks.picker.smart({
              cwd = vim.uv.cwd(),
              finders = { 'buffers', 'recent', 'git_files' },
            })
          end,
          desc = 'Smart Open',
        },

        {
          '<D-p>',
          function()
            Snacks.picker.git_files({})
          end,
          desc = 'Search Files',
        },

        {
          '<leader>sa',
          function()
            Snacks.picker.files()
          end,
          desc = 'Search All files',
        },

        {
          '<D-f>',
          function()
            Snacks.picker.lines({
              layout = {
                -- TODO: research if it's possible to use "ivy" but only win width
                preset = 'telescope',
              },
            })
          end,
        },

        {
          '<D-o>',
          function()
            Snacks.picker.buffers({})
          end,
          desc = 'Search Buffers',
        },

        {
          '<leader>sh',
          function()
            Snacks.picker.help()
          end,
          desc = 'Search Help',
        },
        {
          '<leader>sd',
          function()
            Snacks.picker.diagnostics()
          end,
          desc = 'Search Diagnostics',
        },
        {
          '<leader>sw',
          function()
            Snacks.picker.grep_word()
          end,
          desc = 'Search Word',
        },

        utils.cmd_shift('r', {
          function()
            Snacks.picker.resume()
          end,
          desc = 'Snacks Resume',
        }),

        utils.cmd_shift('p', {
          function()
            Snacks.picker()
          end,
          desc = 'Snacks',
        }),

        {
          '<leader>S.',
          function()
            Snacks.scratch()
          end,
          desc = 'Toggle Scratch Buffer',
        },
        {
          '<leader>SS',
          function()
            Snacks.scratch.select()
          end,
          desc = 'Select Scratch Buffer',
        },
        {
          '<leader>n',
          function()
            Snacks.notifier.show_history()
          end,
          desc = 'Notification History',
        },
        {
          '<leader>un',
          function()
            Snacks.notifier.hide()
          end,
          desc = 'Dismiss All Notifications',
        },
      }
    end,
  },
}
