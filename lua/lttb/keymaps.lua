-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Fix gx, avoid netrw
vim.keymap.set('n', 'gx', '<cmd>!open "<cWORD>"<cr><cr>', { silent = true })

-- cut into system clipboard in visual mode
vim.keymap.set({ 'n', 'x' }, 'd', '"*d')

vim.keymap.set('n', '<C-O>', '<C-O>zv', { remap = true })
vim.keymap.set('n', '<C-I>', '<C-I>zv', { remap = true })

-- Simplify switch no normal mode
vim.keymap.set({ 'i', 'c', 'v', 't' }, '<M-Space>', '<C-\\><C-n>')

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

-- better indenting
-- vim.keymap.set('v', '<', '<gv')
-- vim.keymap.set('v', '>', '>gv')

-- highlights under cursor

-- vim.keymap.set('n', '<leader>sH', vim.show_pos, { desc = 'Highlight Groups at cursor' })

-- buffers
-- vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
-- vim.keymap.set('n', '<leader>bw', '<cmd>bprevious | bd! #<cr>', { silent = true, desc = 'Delete Buffer' })
-- vim.keymap.set('n', '<leader>ww', '<leader>bw', { remap = true })

-- }}}

-- Quick Save shortcut
vim.keymap.set({ 'i', 'n' }, '<D-s>', '<cmd>update<cr>', { desc = 'Quick Save' })

-- TODO: automatically close split if the last buffer in the split was closed
vim.keymap.set('n', '<D-w>', '<cmd>bprevious | bd! #<cr>')
