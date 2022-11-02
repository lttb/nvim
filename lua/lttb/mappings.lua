local utils = require('lttb.utils')

-- Global mappings

-- Fix gx, avoid netrw
vim.keymap.set('n', 'gx', '<cmd>!open "<cWORD>"<cr>', { silent = true })

-- Quick Save shortcut
utils.keyplug('lttb-quick-save', '<esc><cmd>update<cr>')

utils.keymap({ 'i', 'n' }, { '<M-s>', '<D-s>' }, 'lttb-quick-save')

-- Commands

utils.keymap('n', '<S-D-p>', 'lttb-telescope')

utils.keymap('n', { '<leader>/', '<D-f>' }, 'lttb-search-buffer', {
  desc = '[/] Fuzzily search in current buffer',
})

utils.keymap('n', { '<leader>sg', '<S-D-f>' }, 'lttb-search-grep', {
  desc = '[S]earch by [G]rep',
})

utils.keymap('n', '<leader>?', 'lttb-find-recent-files', {
  desc = '[?] Find recently opened files',
})

utils.keymap('n', '<leader><space>', 'lttb-find-buffers', {
  desc = '[ ] Find existing buffers',
})

utils.keymap('n', '<leader>sa', 'lttb-find-all-files', {
  desc = '[S]earch [A]ll files',
})

utils.keymap('n', { '<leader>ss', '<D-p>' }, 'lttb-find-files', {
  desc = '[S]earch Files',
})

utils.keymap('n', '<leader>sf', 'lttb-find-files-submodules', {
  desc = '[S]earch [F]iles Recurse Submodules',
})

utils.keymap('n', '<leader>sh', 'lttb-search-help', {
  desc = '[S]earch [H]elp',
})

utils.keymap('n', '<leader>sw', 'lttb-search-current-word', {
  desc = '[S]earch current [W]ord',
})

utils.keymap('n', '<leader>sd', 'lttb-search-diagnostics', {
  desc = '[S]earch [D]iagnostics',
})
