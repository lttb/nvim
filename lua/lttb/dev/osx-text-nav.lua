local M = {}

function M.setup()
  vim.api.nvim_set_keymap('n', '<A-Left>', 'b', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<A-Right>', 'w', { noremap = true, silent = true })
  -- For moving word back and forth in insert mode, consider using <C-Left> and <C-Right> which are more native to insert mode operations:
  vim.api.nvim_set_keymap('i', '<A-Left>', '<C-Left>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<A-Right>', '<C-Right>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-Left>', 'b', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-Right>', 'w', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', '<A-Left>', '<C-\\><C-N>b', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', '<A-Right>', '<C-\\><C-N>w', { noremap = true, silent = true })

  -- Delete a word: Option + Backspace
  vim.api.nvim_set_keymap('i', '<A-BS>', '<C-W>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<A-BS>', 'db', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-BS>', 'd', { noremap = true, silent = true })

  -- Select to the beginning of the word with Option+Shift+Left
  vim.api.nvim_set_keymap('n', '<A-S-Left>', 'vb', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<A-S-Left>', '<Esc>vb', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-S-Left>', 'b', { noremap = true, silent = true })

  -- Undo with Cmd+Z
  vim.api.nvim_set_keymap('n', '<D-z>', 'u', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<D-z>', '<C-o>u', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<D-z>', '<C-o>u', { noremap = true, silent = true })

  -- Redo with Cmd+Shift+Z
  vim.api.nvim_set_keymap('n', '<S-D-z>', ':redo<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<S-D-z>', '<C-o>:redo<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<S-D-z>', '<C-o>:redo<CR>', { noremap = true, silent = true })
end

return M
