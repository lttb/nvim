return {
  {
    'rcarriga/nvim-notify',
    opts = {
      background_colour = vim.o.background == 'light' and '#ffffff' or '#000000',
    },
    event = 'VeryLazy',
  },
}
