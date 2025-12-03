return {
  {
    'rcarriga/nvim-notify',
    opts = {
      background_color = vim.o.background == 'light' and '#ffffff' or '#000000',
    },
    event = 'VeryLazy',
  },
}
