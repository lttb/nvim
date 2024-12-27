-- vim:fileencoding=utf-8:foldmethod=marker
-- cSpell:words bprevious netrw

local utils = require('lttb.utils')

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Fix gx, avoid netrw
vim.keymap.set('n', 'gx', '<cmd>!open "<cWORD>"<cr><cr>', { silent = true })

-- cut into system clipboard
-- vim.keymap.set({ 'n', 'x' }, 'd', '"_d')
-- vim.keymap.set({ 'n', 'x' }, 'x', '"*d', { remap = false })
-- vim.keymap.set({ 'n' }, 'xx', '"*dd')

vim.keymap.set('n', '<C-O>', '<C-O>zv', { remap = true })
vim.keymap.set('n', '<C-I>', '<C-I>zv', { remap = true })

-- Simplify switch no normal mode
vim.keymap.set({ 'i', 'c', 'v', 't' }, '<M-ESC>', '<C-\\><C-n>')

-- require('lttb.dev.yanka')
local yanka = require('lttb.dev.yanka2')

-- TODO: think about simpler approach
if true then
  vim.keymap.set('n', 'p', function()
    vim.api.nvim_feedkeys('o', 'n', false)
    vim.schedule(function()
      yanka.put_with_autoindent()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'i', true)
    end)
  end)
  vim.keymap.set('n', 'P', function()
    vim.api.nvim_feedkeys('O', 'n', false)
    vim.schedule(function()
      yanka.put_with_autoindent()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'i', true)
    end)
  end)
end

if utils.is_vscode() then
  return
end

require('lttb.dev.macos-text-nav').setup()

-- @see https://github.com/LazyVim/LazyVim/blob/30b7215de80a215c9bc72640505ea76431ff515c/lua/lazyvim/config/keymaps.lua

-- better up/down
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<c-w>h', { desc = 'Go to left window', silent = true })
vim.keymap.set('n', '<C-j>', '<c-j>h', { desc = 'Go to lower window', silent = true })
vim.keymap.set('n', '<C-k>', '<c-k>h', { desc = 'Go to upper window', silent = true })
vim.keymap.set('n', '<C-l>', '<c-l>h', { desc = 'Go to right window', silent = true })

-- Move to window using the <ctrl> hjkl keys and `vim-kitty-navigator`
-- vim.keymap.set('n', '<C-h>', ':KittyNavigateLeft<cr>', { desc = 'Go to left window', silent = true })
-- vim.keymap.set('n', '<C-j>', ':KittyNavigateDown<cr>', { desc = 'Go to lower window', silent = true })
-- vim.keymap.set('n', '<C-k>', ':KittyNavigateUp<cr>', { desc = 'Go to upper window', silent = true })
-- vim.keymap.set('n', '<C-l>', ':KittyNavigateRight<cr>', { desc = 'Go to right window', silent = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- vim.keymap.set('n', '<C-D>', '25j', { desc = 'Better Scroll Down' })
-- vim.keymap.set('n', '<C-U>', '25k', { desc = 'Better Scroll Up' })

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

-- Auto indent on empty line.
vim.keymap.set('n', 'i', function()
  return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i'
end, { expr = true, remap = false })

-- More granular undo in insert mode
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>', { remap = false })
vim.keymap.set('i', '<C-w>', '<C-g>u<C-w>')
vim.keymap.set('i', '<D-z>', '<C-w>')

-- Quick Save shortcut
vim.keymap.set({ 'i', 'n' }, '<D-s>', function()
  vim.cmd('update')
end, { desc = 'Quick Save' })

-- TODO: automatically close split if the last buffer in the split was closed
vim.keymap.set('n', '<D-w>', '<cmd>lua MiniBufremove.delete()<cr>')

function FormatPasted()
  -- Get the lines where the last paste occurred
  local from_row, from_col = unpack(vim.api.nvim_buf_get_mark(0, '['))
  local to_row, to_col = unpack(vim.api.nvim_buf_get_mark(0, ']'))

  vim.lsp.buf.format({
    async = false,
    range = {
      start = { from_row, from_col },
      ['end'] = { to_row, to_col },
    },
  })
end

vim.keymap.set('n', '/', 'zR/', { remap = false })

-- vim.keymap.set('i', '<S-D-v>', '<C-r><C-p>+<cmd>lua FormatPasted()<CR>', { noremap = true, silent = true })

-- more refined paste
-- vim.keymap.set('i', '<D-v>', '<C-r><C-p>+')

vim.keymap.set('x', '<D-x>', '"+d')
vim.keymap.set('n', '<D-x>', '"+dd')
vim.keymap.set('x', '<D-c>', 'y')
vim.keymap.set('n', '<D-c>', 'yy')
vim.keymap.set({ 'i', 'n', 't', 'x' }, '<D-v>', yanka.put_with_autoindent, { noremap = true, silent = true })
vim.keymap.set('c', '<D-v>', '<C-r>+')

vim.keymap.set({ 'n', 'x', 'i', 't' }, '<D-k>', function()
  vim.opt.eventignore:append('WinLeave,BufLeave')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'i', true)
end)

-- vim.keymap.set({ 'n', 'x', 'i', 't' }, '<D-d>', require('lttb.dev.toggle_floats').toggle_floats)
