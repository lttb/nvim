local utils = require('lttb.utils')

-- Global mappings

-- Fix gx, avoid netrw
vim.keymap.set('n', 'gx', '<cmd>!open "<cWORD>"<cr><cr>', { silent = true })

-- Substitute remaps
utils.keymap('n', '<leader>x', 'lttb-substiture-operator', {
  desc = 'Substitute',
  noremap = true,
})
utils.keymap('x', '<leader>x', 'lttb-substiture-visual', {
  desc = 'Substitute visual selection',
  noremap = true,
})
vim.keymap.set(
  'n',
  '<leader>xx',
  "<cmd>lua require('substitute.exchange').operator()<cr>",
  { noremap = true }
)

-- Char motions

-- Simplify switch no normal mode
vim.keymap.set({ 'n', 'i', 'c', 'v', 't' }, '<S-Space>', '<C-\\><C-n>')

-- Quick Save shortcut
utils.keyplug('lttb-quick-save', '<esc><cmd>update<cr>')

utils.keymap({ 'i', 'n' }, { '<M-s>', '<D-s>' }, 'lttb-quick-save')

-- Copilot remap
vim.keymap.set('i', '<D-l>', '<C-l>', { remap = true })

-- Sidebar
utils.keymap('n', '<leader>b', 'lttb-sidebar-toggle', {
  desc = 'Toggle sidebar',
})

utils.keymap('n', '<leader>e', 'lttb-sidebar-focus', {
  desc = 'Focus sidebar',
})

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

-- Terminal

utils.keymap({ 'n', 't', 'i' }, { '<C-j>', '<D-j>' }, 'lttb-toggle-term', {
  desc = 'Toggle terminal',
})

-- LSP

utils.keymap('n', { '<leader>ca', '<D-.>' }, 'lttb-lsp-code-action', {
  desc = 'LSP: [C]ode [A]ction',
})

utils.keymap('n', '<leader>rn', 'lttb-lsp-rename', {
  desc = 'LSP: [R]e[n]ame',
})

utils.keymap('n', 'gd', 'lttb-lsp-definition', {
  desc = 'LSP: [G]oto [D]efinition',
})

utils.keymap('n', 'gi', 'lttb-lsp-implementation', {
  desc = 'LSP: [G]oto [I]mplementation',
})

utils.keymap('n', 'gr', 'lttb-lsp-references', {
  desc = 'LSP: [G]oto [R]eferences',
})

utils.keymap('n', '<leader>ds', 'lttb-lsp-document-symbols', {
  desc = 'LSP: [D]ocument [S]ymbols',
})

utils.keymap('n', '<leader>ws', 'lttb-lsp-workspace-symbols', {
  desc = 'LSP: [W]orkspace [S]ymbols',
})

-- See `:help K` for why this keymap
utils.keymap('n', { 'gh' }, 'lttb-lsp-hover', {
  desc = 'LSP: Hover Documentation',
})

utils.keymap('n', '<C-k>', 'lttb-lsp-signature-help', {
  desc = 'LSP: Signature Documentation',
})

utils.keymap('n', 'gD', 'lttb-lsp-declaration', {
  desc = 'LSP: [G]oto [D]eclaration',
})

utils.keymap('n', '<leader>D', 'lttb-lsp-type-definition', {
  desc = 'LSP: Type [D]efinition',
})

utils.keymap('n', '<leader>wa', 'lttb-lsp-add-workspace-folder', {
  desc = 'LSP: [W]orkspace [A]dd Folder',
})

utils.keymap('n', '<leader>wr', 'lttb-lsp-remove-workspace-folder', {
  desc = 'LSP: [W]orkspace [R]emove Folder',
})

utils.keymap('n', '<leader>wl', 'lttb-lsp-list-workspace-folders', {
  desc = 'LSP: [W]orkspace [L]ist Folders',
})
