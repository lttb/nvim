local utils = require('lttb.utils')

-- Global mappings

-- Quick Save shortcut
vim.keymap.set({ 'i', 'n' }, '<M-s>', '<esc><cmd>update<cr>')
vim.keymap.set({ 'i', 'n' }, '<D-s>', '<esc><cmd>update<cr>')

-- Fix gx, avoid netrw
vim.keymap.set('n', 'gx', '<cmd>!open "<cWORD>"<cr>', { silent = true })

-- Commands

utils.keymap('n', '<S-D-p>', 'lttb-telescope')

utils.keymap('n', { '<leader>/', '<D-f>' }, 'lttb-search-buffer', {
  desc = '[/] Fuzzily search in current buffer',
})

utils.keymap('n', '<leader>?', 'lttb-find-recent-files', {
  desc = '[?] Find recently opened files',
})
