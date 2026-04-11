local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

-- Borderless padded border matching the hover float aesthetic from commit 6a234d8
-- (8x space characters highlighted as NormalFloat -> 1-cell pad, no visible border).
local borderless_padded = {
  { ' ', 'NormalFloat' },
  { ' ', 'NormalFloat' },
  { ' ', 'NormalFloat' },
  { ' ', 'NormalFloat' },
  { ' ', 'NormalFloat' },
  { ' ', 'NormalFloat' },
  { ' ', 'NormalFloat' },
  { ' ', 'NormalFloat' },
}

return {
  {
    'rachartier/tiny-cmdline.nvim',
    lazy = false,
    priority = 900,
    init = function()
      vim.o.cmdheight = 0
    end,
    config = function()
      -- Experimental Neovim 0.12 UI2: replaces the builtin cmdline + message
      -- presentation layer. We route non-cmdline messages to the ephemeral
      -- floating "msg" window (hence the snacks notifier is disabled).
      require('vim._core.ui2').enable({
        msg = {
          targets = 'msg',
          msg = {
            height = 0.5,
            timeout = 6000,
          },
        },
      })

      require('tiny-cmdline').setup({
        width = { value = '60%' },
        position = { x = '50%', y = '50%' },
        border = borderless_padded,
      })
    end,
  },
}
