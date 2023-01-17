-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

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
vim.keymap.set('n', '<leader>xx', "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })

-- cut into system clipboard in visual mode
vim.keymap.set('v', 'x', '"*x')

-- Char motions
-- utils.keymap('n', 's', 'lttb-hop-on')

-- Simplify switch no normal mode
vim.keymap.set({ 'n', 'i', 'c', 'v', 't' }, '<S-Space>', '<C-\\><C-n>')

if utils.is_vscode() then
  return
end

-- {{{ Text editing navigation

vim.keymap.set('x', '<BS>', 'd')

local function native_nav(key, ncmd, icmd, xcmd)
  vim.keymap.set('n', key, ncmd, { remap = true })
  vim.keymap.set('i', key, '<esc>' .. key .. (icmd or ''), { remap = true })
  if xcmd then
    vim.keymap.set('x', key, xcmd, { remap = true })
  end
end

native_nav('<M-BS>', ',bda,w', 'i')
native_nav('<M-DEL>', 'da,w', 'i')

native_nav('<S-Left>', 'vh', '', 'h')
native_nav('<S-Right>', 'vl', '', 'l')
native_nav('<S-Up>', 'vk', '', 'k')
native_nav('<S-Down>', 'vj', '', 'j')

native_nav('<M-Left>', ',b', 'i')
native_nav('<M-Right>', ',e,w', 'i')

native_nav('<M-S-Left>', ',ev,b', '', ',b')
native_nav('<M-S-Right>', 'vi,w', '', ',w')
-- }}}

-- {{{ Global mappings

-- @see https://github.com/LazyVim/LazyVim/blob/30b7215de80a215c9bc72640505ea76431ff515c/lua/lazyvim/config/keymaps.lua

-- better up/down
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Clear search with <esc>
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- highlights under cursor
if vim.fn.has('nvim-0.9.0') == 1 then
  vim.keymap.set('n', '<leader>sH', vim.show_pos, { desc = 'Highlight Groups at cursor' })
end

-- buffers
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>bw', '<cmd>bdelete!<cr>', { desc = 'Delete Buffer' })

-- }}}

-- Quick Save shortcut
utils.keyplug('lttb-quick-save', '<esc><cmd>update<cr>')
utils.keymap({ 'i', 'n' }, { '<M-s>', '<D-s>' }, 'lttb-quick-save')

-- Copilot remap
-- vim.keymap.set('i', '<D-l>', '<C-l>', { remap = true })

-- Sidebar
utils.keymap('n', '<M-b>', 'lttb-sidebar-toggle', {
  desc = 'Toggle sidebar',
})

utils.keymap('n', '<M-e>', 'lttb-sidebar-focus', {
  desc = 'Focus sidebar',
})

-- Terminal

utils.keymap({ 'n', 't', 'i' }, { '<M-j>', '<D-j>' }, 'lttb-toggle-term', {
  desc = 'Toggle terminal',
})

-- Commands
utils.keymap('n', '<S-D-p>', 'lttb-telescope')

vim.keymap.set('n', '<leader>/', '/', {
  noremap = true,
})

utils.keymap('n', { '/', '<D-f>' }, 'lttb-search-buffer', {
  desc = '[/] Fuzzily search in current buffer',
  noremap = true,
})

utils.keymap('n', { '<leader>sg', '<S-D-f>' }, 'lttb-search-grep', {
  desc = '[S]earch by [G]rep',
})

utils.keymap('n', '<leader>?', 'lttb-find-recent-files', {
  desc = '[?] Find recently opened files',
})

utils.keymap('n', '<leader><leader>', 'lttb-smart-open', {
  desc = '[ ] Find existing buffers',
})

utils.keymap('n', '<leader>sb', 'lttb-find-buffers', {
  desc = '[S] Find existing [B]uffers',
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

-- LSP

utils.keymap('n', { '<leader>ca', '<D-.>', '<C-.>' }, 'lttb-lsp-code-action', {
  desc = 'LSP: [C]ode [A]ction',
})

utils.keymap('n', '<leader>rn', 'lttb-lsp-rename', {
  desc = 'LSP: [R]e[n]ame',
})

utils.keymap('n', '<leader>ds', 'lttb-lsp-document-symbols', {
  desc = 'LSP: [D]ocument [S]ymbols',
})

utils.keymap('n', '<leader>ws', 'lttb-lsp-workspace-symbols', {
  desc = 'LSP: [W]orkspace [S]ymbols',
})

utils.keymap('n', { 'gh', 'K' }, 'lttb-lsp-hover', {
  desc = 'LSP: Hover Documentation',
})
utils.keymap('n', { 'gK' }, 'lttb-lsp-hover-select', {
  desc = 'LSP: Hover Documentation Select',
})
utils.keymap('n', { 'gh' }, 'lttb-lsp-hover-native', {
  desc = 'LSP: Hover Documentation Native',
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

utils.keymap('n', '<leader>D', 'lttb-lsp-type-definition', {
  desc = 'LSP: Type [D]efinition',
})

utils.keymap('n', 'gD', 'lttb-lsp-declaration', {
  desc = 'LSP: [G]oto [D]eclaration',
})

utils.keymap('n', '<C-k>', 'lttb-lsp-signature-help', {
  desc = 'LSP: Signature Documentation',
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
