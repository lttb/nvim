-- TODO: work on the hl for yankayanked text
vim.api.nvim_set_hl(0, 'YankaYanked', {
  bg = '#FFFFFF',
})

local yanka_ns = vim.api.nvim_create_namespace('Yanka_NS')

function trim_string(str)
  -- Use Lua pattern matching to remove leading and trailing spaces, newlines, and tabs
  return str:match('^%s*(.-)%s*$')
end

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
  local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})

  local min_indent = find_minimum_indentation(lines)
  local text_indented = table.concat(
    vim.tbl_map(function(line)
      return line:sub(#min_indent + 1)
    end, lines),
    '\n'
  )

  local trimmed_text = trim_string(text_indented)

  -- print('yy', text_indented, trimmed_text)

  vim.fn.setreg('"', trimmed_text)
  -- vim.fn.setreg('+', trimmed_text)

  vim.api.nvim_exec_autocmds('TextYankPost', {
    pattern = '*',
    modeline = false,
    data = {
      operator = 'y',
      regcontents = { trimmed_text },
      regname = '"',
      regtype = 'v',
    },
  })

  vim.highlight.range(0, yanka_ns, 'YankaYanked', { start_line, start_col }, { end_line, end_col },
    {
      inclusive = false,
      priority = 10000,
    })

  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, yanka_ns, 0, -1)
  end, 300)
end

function Visual_trim_and_yank()
  local start_mark, end_mark = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local start_line, end_line = start_mark[2] - 1, end_mark[2] - 1
  local start_col, end_col = start_mark[3] - 1, end_mark[3] - 1

  trim_and_yank_text(start_line, end_line, start_col, end_col)
end

function Normal_trim_and_yank()
  local current_line = vim.fn.line('.') - 1
  trim_and_yank_text(current_line, current_line, 0, -1)
end

function Operator_trim_and_yank()
  local start_mark, end_mark = vim.fn.getpos("'["), vim.fn.getpos("']")
  local start_line, end_line = start_mark[2] - 1, end_mark[2] - 1
  local start_col, end_col = start_mark[3] - 1, end_mark[3] - 1

  -- some weird stuff
  if start_line ~= end_line then
    end_line = end_line + 1
  end

  trim_and_yank_text(start_line, end_line, start_col, end_col)
end

vim.api.nvim_create_user_command('VisualTrimYank', Visual_trim_and_yank, {})
vim.api.nvim_set_keymap('x', 'Y', ':lua Visual_trim_and_yank()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Y', ':set opfunc=v:lua.Operator_trim_and_yank<CR>g@', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'YY', ':lua Normal_trim_and_yank()<CR>', { noremap = true, silent = true })
