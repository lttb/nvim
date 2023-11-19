vim.api.nvim_set_keymap('x', 'gc', '<Plug>VSCodeCommentary', {})
vim.api.nvim_set_keymap('n', 'gc', '<Plug>VSCodeCommentary', {})
vim.api.nvim_set_keymap('o', 'gc', '<Plug>VSCodeCommentary', {})
vim.api.nvim_set_keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})

vim.api.nvim_set_keymap('n', 'gr', ':call VSCodeNotify("workbench.action.goToReferences")<cr>', {})

vim.api.nvim_set_keymap('n', '<leader><leader>', ':call VSCodeNotify("workbench.action.quickOpen")<cr>', {})
