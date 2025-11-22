return {
  {
    -- extended treesitter objects
    'chrisgrieser/nvim-various-textobjs',
    vscode = true,
    event = 'LazyFile',
    opts = { keymaps = { useDefaults = true, disabledDefaults = { 'gc' } } },
  },
}
