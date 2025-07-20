local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

if true then
  return {}
end

return {
  'Eutrius/Otree.nvim',
  lazy = false,
  dependencies = {
    -- Optional: Enhanced file operations
    'stevearc/oil.nvim',
    -- Optional: Icon support
    { 'echasnovski/mini.icons', opts = {} },
    -- "nvim-tree/nvim-web-devicons",
  },
  opts = {
    open_on_startup = true,
    win_size = 50,
    lsp_signs = true,
    git_signs = true,
  },
}
