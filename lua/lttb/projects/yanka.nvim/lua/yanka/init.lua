local M = {}

local function trim_string_r(str)
  -- Use Lua pattern matching to remove trailing spaces, newlines, and tabs
  return str:match('(.-)%s*$')
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

-- TODO: implement indentation balancing
local function trim_text(text)
  local lines = vim.split(trim_string_r(text), '\n')

  local min_indent = find_minimum_indentation(lines)

  local new_lines = vim.tbl_map(function(line)
    return line:sub(#min_indent + 1)
  end, lines)

  return new_lines
end

local g = vim.api.nvim_create_augroup('Yanka_AUG', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = g,
  pattern = '*',
  desc = '[YankaYank]',
  callback = function(args)
    local is_yanka = args and args.data and args.data._yanka

    if is_yanka then
      return
    end

    -- @see https://github.com/ibhagwan/smartyank.nvim/blob/7e3905578f646503525b2f7018b8afd17861018c/lua/smartyank/init.lua#L146-L147
    -- get yank data from the unnamed register (not yank register 0)
    -- or we will acquire the wrong yank data when `validate_yank == false`
    local yank_data = vim.fn.getreg([["]])

    -- NOTE: reconcat to force to drop the trailing \n
    local trimmed_text = table.concat(trim_text(yank_data), '\n')

    -- vim.fn.setreg('"', trimmed_text)
    vim.fn.setreg('+', trimmed_text)

    -- vim.api.nvim_exec_autocmds('TextYankPost', {
    --   pattern = '*',
    --   modeline = false,
    --   data = {
    --     _yanka = true,
    --     operator = 'y',
    --     regcontents = trimmed_text,
    --     regname = '"',
    --     regtype = 'v',
    --   },
    -- })
  end,
})

function M.put_with_autoindent()
  -- Get current line number and its indentation
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local current_indent = vim.fn.indent(current_line)

  -- Detect whether the indentation uses spaces or tabs
  local current_line_content = vim.fn.getline(current_line)
  local indent_char = current_line_content:match('^%s') or ' '
  local indent_string = indent_char:rep(current_indent)

  -- Get the content from the clipboard
  local clipboard_content = vim.fn.getreg('+')

  -- Create an iterator for the lines in clipboard content
  local lines = trim_text(clipboard_content)
  local new_lines = {}

  for i, v in ipairs(lines) do
    table.insert(new_lines, (i == 1 and '' or indent_string) .. v)
  end

  -- Paste the modified content
  vim.api.nvim_put(new_lines, '', false, true)
end

function M.setup()
  -- TODO: make it configurable
  vim.keymap.set('n', 'p', function()
    vim.api.nvim_feedkeys('o', 'n', false)
    vim.schedule(function()
      M.put_with_autoindent()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'i', true)
    end)
  end)

  vim.keymap.set('n', 'P', function()
    vim.api.nvim_feedkeys('O', 'n', false)
    vim.schedule(function()
      M.put_with_autoindent()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'i', true)
    end)
  end)
end

return M
