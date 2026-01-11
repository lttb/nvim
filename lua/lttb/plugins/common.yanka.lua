return {
  {
    'lttb/yanka.nvim',
    vscode = true,
    event = 'LazyFile',
    opts = {},
    keys = {
      -- { 'y', '<Plug>(YankyYank)', mode = { 'x', 'n' } },
      -- { '<D-c>', '<Plug>(YankyYank)', mode = { 'x' } },
      -- { 'y', 'my<cmd>normal! y<cr>`y<cmd>redraw!<cr>', mode = { 'x' } },
      { '<D-c>', 'my<cmd>normal! y<cr>`y<cmd>redraw!<cr>', mode = { 'x' } },
      { '<D-x>', '"+d',                                    mode = { 'x' } },
      { '<D-x>', 'yy"+dd',                                 mode = { 'n' } },
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
}
