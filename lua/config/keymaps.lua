-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

-- cut into system clipboard in visual mode
vim.keymap.set({ 'n', 'x' }, 'd', '"*d')

vim.keymap.set('n', '<C-O>', '<C-O>zv', { remap = true })
vim.keymap.set('n', '<C-I>', '<C-I>zv', { remap = true })

if utils.is_vscode() then
	return
end

-- {{{ Text editing navigation

vim.keymap.set('x', '<BS>', 'd')

local function native_nav(key, ncmd, icmd, xcmd)
	vim.keymap.set('n', key, ncmd, { remap = true })
	vim.keymap.set(
		'i',
		key,
		'<cmd>set eventignore=InsertLeave<cr><esc>' .. key .. '<cmd>set eventignore=""<cr>' .. (icmd or ''),
		{ remap = true }
	)
	if xcmd then
		vim.keymap.set('x', key, xcmd, { remap = true })
	end
end

native_nav('<M-BS>', 'ldb', 'i')
native_nav('<M-DEL>', 'edaw', 'i')

native_nav('<S-Left>', 'vh', '', 'h')
native_nav('<S-Right>', 'vl', '', 'l')
native_nav('<S-Up>', 'vk', '', 'k')
native_nav('<S-Down>', 'vj', '', 'j')

native_nav('<M-Left>', 'b', 'i')
native_nav('<M-Right>', 'e', 'a')

native_nav('<M-S-Left>', 'evb', '', ',b')
native_nav('<M-S-Right>', 'vie', '', ',w')
-- }}}

-- Quick Save shortcut
utils.keyplug('lttb-quick-save', function()
	vim.cmd('update')
end)
utils.nkeymap({ 'i', 'n' }, { '<D-s>' }, 'lttb-quick-save')

-- Alt commands {{{

-- TODO: automatically close split if the last buffer in the split was closed
vim.keymap.set('n', '<D-w>', '<cmd>bdelete')

-- Sidebar
utils.keymap('n', { '<D-b>' }, 'lttb-sidebar-toggle', {
	desc = 'Toggle sidebar',
})

utils.keymap('n', { '<D-e>' }, 'lttb-sidebar-focus', {
	desc = 'Focus sidebar',
})

-- Terminal

utils.nkeymap({ 'n', 't', 'i' }, { '<D-j>' }, 'lttb-toggle-term', {
	desc = 'Toggle terminal',
})

-- }}}

-- Commands
utils.keymap('n', '<S-D-p>', 'lttb-telescope')

utils.keymap('n', { '<D-f>' }, 'lttb-search-buffer', {
	desc = '[/] Fuzzily search in current buffer',
	noremap = true,
})
