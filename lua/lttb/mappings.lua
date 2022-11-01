-- Global mappings

-- Quick Save shortcut
vim.keymap.set({ 'i', 'n' }, '<m-s>', '<esc><cmd>update<cr>')

-- Fix gx, avoid netrw
vim.keymap.set('n', 'gx', '<cmd>!open "<cWORD>"<cr>', { silent = true })
