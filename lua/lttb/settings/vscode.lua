vim.api.nvim_set_keymap('x', 'gc', '<Plug>VSCodeCommentary', {})
vim.api.nvim_set_keymap('n', 'gc', '<Plug>VSCodeCommentary', {})
vim.api.nvim_set_keymap('o', 'gc', '<Plug>VSCodeCommentary', {})
vim.api.nvim_set_keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})

vim.api.nvim_set_keymap('n', 'gr', ':call VSCodeNotify("workbench.action.goToReferences")<cr>', {})

vim.api.nvim_set_keymap('n', '<leader><leader>', ':call VSCodeNotify("find-it-faster.findFiles")<cr>', {})
vim.api.nvim_set_keymap('n', '/', ':call VSCodeNotify("go-to-fuzzy.find")<cr>', {})
