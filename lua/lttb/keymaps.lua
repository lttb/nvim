-- vim:fileencoding=utf-8:foldmethod=marker
-- cSpell:words bprevious netrw

local utils = require('lttb.utils')

-- quit
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Fix gx, avoid netrw
vim.keymap.set('n', 'gx', '<cmd>!open "<cWORD>"<cr><cr>', { silent = true })

-- cut into system clipboard
vim.keymap.set({ 'n', 'x' }, 'd', '"_d')
vim.keymap.set({ 'n', 'x' }, 'x', '"*d', { remap = false })
vim.keymap.set({ 'n' }, 'xx', '"*dd')

vim.keymap.set('n', '<C-O>', '<C-O>zv', { remap = true })
vim.keymap.set('n', '<C-I>', '<C-I>zv', { remap = true })

-- Simplify switch no normal mode
vim.keymap.set({ 'i', 'c', 'v', 't' }, '<M-ESC>', '<C-\\><C-n>')

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

local wm = ''

native_nav('<M-BS>', 'ldb', 'i')
native_nav('<M-DEL>', wm .. 'exa' .. wm .. 'w', 'i')

native_nav('<S-Left>', 'vh', '', 'h')
native_nav('<S-Right>', 'vl', '', 'l')
native_nav('<S-Up>', 'vk', '', 'k')
native_nav('<S-Down>', 'vj', '', 'j')

native_nav('<M-Left>', wm .. 'b', 'i')
native_nav('<M-Right>', wm .. 'e', 'a')

native_nav('<M-S-Left>', wm .. 'ev' .. wm .. 'b', '', ',b')
native_nav('<M-S-Right>', 'vi' .. wm .. 'e', '', ',w')
-- }}}

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

-- Auto indent on empty line.
vim.keymap.set('n', 'i', function()
  return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'cc' or 'i'
end, { expr = true, remap = false })

-- More granular undo in insert mode
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>', { remap = false })
vim.keymap.set('i', '<C-w>', '<C-g>u<C-w>')
vim.keymap.set('i', '<D-z>', '<C-w>')

-- Quick Save shortcut
vim.keymap.set({ 'i', 'n' }, '<D-s>', '<cmd>update<cr>', { desc = 'Quick Save' })

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

vim.keymap.set('i', '<S-D-v>', '<C-r><C-p>+<cmd>lua FormatPasted()<CR>', { noremap = true, silent = true })

-- more refined paste
-- vim.keymap.set('i', '<D-v>', '<C-r><C-p>+')

local function trim_and_yank(start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  local min_indent = nil
  for _, line in ipairs(lines) do
    local indent = line:match('^%s*')
    if min_indent == nil or #indent < #min_indent then
      min_indent = indent
    end
  end

  local trimmed_text = table.concat(vim.tbl_map(function(line)
    return line:sub(#min_indent + 1)
  end, lines), '\n')

  vim.fn.setreg('"', trimmed_text)
  vim.fn.setreg('+', trimmed_text)
  vim.api.nvim_exec('silent! doautocmd <nomodeline> TextYankPost', false)
end

function visual_trim_and_yank()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  trim_and_yank(start_line, end_line)
end

function normal_trim_and_yank()
  local current_line = vim.fn.line('.')
  trim_and_yank(current_line, current_line)
end

function operator_trim_and_yank()
  local start_mark = vim.fn.getpos("'[")
  local end_mark = vim.fn.getpos("']")

  -- Convert marks to 1-based indices (line and column)
  local start_line, start_col = start_mark[2], start_mark[3]
  local end_line, end_col = end_mark[2], end_mark[3]

  -- Adjust the end position for character-wise operation
  if vim.v.operator ~= 'line' and end_col > 0 then
    end_col = end_col + 1
  end

  -- Retrieve the lines in the range
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then return end

  -- If operation is on the same line, extract the specific part
  if start_line == end_line then
    lines[1] = lines[1]:sub(start_col, end_col - 1)
  end

  -- Find minimum indentation and trim
  local min_indent = nil
  for _, line in ipairs(lines) do
    local indent = line:match('^%s*')
    if not min_indent or #indent < #min_indent then
      min_indent = indent
    end
  end

  local trimmed_text = table.concat(vim.tbl_map(function(line)
    return line:sub(#min_indent + 1)
  end, lines), '\n')

  -- Yank the trimmed text
  vim.fn.setreg('"', trimmed_text)
  vim.fn.setreg('+', trimmed_text)

  -- Trigger TextYankPost event
  vim.api.nvim_exec('silent! doautocmd <nomodeline> TextYankPost', false)
end

vim.api.nvim_create_user_command('VisualTrimYank', visual_trim_and_yank, {})
vim.api.nvim_create_user_command('NormalTrimYank', normal_trim_and_yank, {})

vim.api.nvim_set_keymap('x', 'Y', ':lua visual_trim_and_yank()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Y', ':set opfunc=v:lua.operator_trim_and_yank<CR>g@', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'YY', ':NormalTrimYank<CR>', { noremap = true, silent = true })
