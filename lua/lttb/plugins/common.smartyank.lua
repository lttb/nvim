return {
  {
    -- NOTE: it seems that this plugin triggers cmdline focus
    vscode = true,
    'ibhagwan/smartyank.nvim',
    event = 'LazyFile',
    opts = {
      highlight = {
        enabled = true, -- highlight yanked text
        higroup = 'CursorLine', -- highlight group of yanked text
        timeout = 200, -- timeout for clearing the highlight
      },
      clipboard = { enabled = true },
      tmux = {
        enabled = false,
        -- remove `-w` to disable copy to host client's clipboard
        cmd = { 'tmux', 'set-buffer', '-w' },
      },
      osc52 = {
        enabled = true,
        ssh_only = true, -- false to OSC52 yank also in local sessions
        silent = true, -- true to disable the "n chars copied" echo
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
}
