return {
  {
    'chrisgrieser/nvim-spider',
    vscode = true,
    keys = {
      {
        'e',
        "<cmd>lua require('spider').motion('e')<CR>",
        desc = 'Spider-e',
        mode = { 'n', 'o', 'x' },
      },
      {
        'w',
        "<cmd>lua require('spider').motion('w')<CR>",
        desc = 'Spider-w',
        mode = { 'n', 'o', 'x' },
      },
      {
        'b',
        "<cmd>lua require('spider').motion('b')<CR>",
        desc = 'Spider-b',
        mode = { 'n', 'o', 'x' },
      },
      {
        'ge',
        "<cmd>lua require('spider').motion('ge')<CR>",
        desc = 'Spider-ge',
        mode = { 'n', 'o', 'x' },
      },
    },
  },
}
