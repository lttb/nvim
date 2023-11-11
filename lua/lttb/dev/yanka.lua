local function find_minimum_indentation(lines)
  local min_indent = nil
  for _, line in ipairs(lines) do
    -- Ignore lines that are blank or only contain whitespace
    if line:match('%S') then
      local indent = line:match('^%s*')
      if not min_indent or #indent < #min_indent then
        min_indent = indent
      end
    end
  end
  return min_indent or ''
end

local function trim_and_yank_text(start_line, end_line, start_col, end_col)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if start_line == end_line and #lines > 0 and start_col and end_col then
    lines[1] = lines[1]:sub(start_col, end_col - 1)
  end

  local min_indent = find_minimum_indentation(lines)
  local trimmed_text = table.concat(vim.tbl_map(function(line)
    return line:sub(#min_indent + 1)
  end, lines), '\n')

  vim.fn.setreg('"', trimmed_text)
  vim.fn.setreg('+', trimmed_text)
  vim.api.nvim_exec('silent! doautocmd <nomodeline> TextYankPost', false)
end

function visual_trim_and_yank()
  local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
  trim_and_yank_text(start_line, end_line)
end

function normal_trim_and_yank()
  local current_line = vim.fn.line('.')
  trim_and_yank_text(current_line, current_line)
end

function operator_trim_and_yank()
  local start_mark, end_mark = vim.fn.getpos("'["), vim.fn.getpos("']")
  local start_line, end_line = start_mark[2], end_mark[2]
  local start_col, end_col = start_mark[3], end_mark[3]

  -- Adjust the end position for character-wise operation
  if vim.v.operator ~= 'line' and end_col > 0 then
    end_col = end_col + 1
  end

  trim_and_yank_text(start_line, end_line, start_col, end_col)
end

vim.api.nvim_create_user_command('VisualTrimYank', visual_trim_and_yank, {})
vim.api.nvim_set_keymap('x', 'Y', ':lua visual_trim_and_yank()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Y', ':set opfunc=v:lua.operator_trim_and_yank<CR>g@', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'YY', ':lua normal_trim_and_yank()<CR>', { noremap = true, silent = true })
