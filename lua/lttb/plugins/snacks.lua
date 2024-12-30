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
      indent = {
        enabled = true,

        animate = {
          enabled = false,
        },

        indent = {
          char = '┊',
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
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
    -- stylua: ignore
    keys = function()
      local Snacks = require('snacks')

      return {
        { '<leader>n',  function() Snacks.notifier.show_history() end, desc = 'Notification History' },
        { '<leader>un', function() Snacks.notifier.hide() end,         desc = 'Dismiss All Notifications' },
      }
    end,
  },

}
