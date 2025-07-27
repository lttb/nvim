local M = {}

function M.setup()
  -- Normal Mode Shortcuts
  vim.api.nvim_set_keymap('n', '<A-Left>', 'b', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<A-Right>', 'e', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<A-BS>', 'db', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<D-Left>', '^', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<D-Right>', '$', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<A-S-Left>', 'vb', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<A-S-Right>', 've', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<D-z>', 'u', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<D-S-z>', '<C-r>', { noremap = true, silent = true })

  -- Insert Mode Shortcuts
  vim.api.nvim_set_keymap('i', '<A-Left>', '<C-Left>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<A-Right>', '<C-Right>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<A-BS>', '<C-w>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<A-DEL>', '<C-o>ce', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<D-Left>', '<Home>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<D-Right>', '<End>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<A-S-Left>', '<Esc>vbi', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<A-S-Right>', '<Esc>vea', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<D-z>', '<C-o>u', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<D-S-z>', '<C-o><C-r>', { noremap = true, silent = true })

  -- Visual Mode Shortcuts
  vim.api.nvim_set_keymap('v', '<A-Left>', 'b', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-Right>', 'e', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-BS>', 'd', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-S-Left>', 'B', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<A-S-Right>', 'e', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<D-z>', 'u', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<D-S-z>', '<C-r>', { noremap = true, silent = true })

  -- Terminal Mode Shortcuts
  vim.api.nvim_set_keymap('t', '<A-Left>', '<C-Left>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', '<A-Right>', '<C-Right>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', '<A-BS>', '<C-w>', { noremap = true, silent = true })
end

return M
