local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
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
      local Snacks = require('snacks')

      return {
        { '<leader>n',  function() Snacks.notifier.show_history() end, desc = 'Notification History' },
        { '<leader>un', function() Snacks.notifier.hide() end,         desc = 'Dismiss All Notifications' },
      }
    end,
  },
}
