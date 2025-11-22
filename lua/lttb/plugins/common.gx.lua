return {
  {
    'chrishrb/gx.nvim',
    vscode = true,
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    cmd = { 'Browse' },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    config = true,
    submodules = false,
  },
}
