return {
  {
    'kwkarlwang/bufjump.nvim',
    event = 'VeryLazy',
    opts = {
      on_success = function()
        vim.cmd([[execute "normal! g`\"zz"]])
      end,
    },
    keys = {
      { '<C-P>', ":lua require('bufjump').backward()<cr>",          mode = { 'n' }, silent = true },
      { '<C-N>', ":lua require('bufjump').forward()<cr>",           mode = { 'n' }, silent = true },
      { '<M-o>', ":lua require('bufjump').backward_same_buf()<cr>", mode = { 'n' }, silent = true },
      { '<M-i>', ":lua require('bufjump').forward_same_buf()<cr>",  mode = { 'n' }, silent = true },
    },
  },
}
