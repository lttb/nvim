local function trim_string(str)
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
    local ok, yank_data = pcall(vim.fn.getreg, [["]])

    if not ok then
      return
    end

    local lines = vim.split(yank_data, '\n')
    local min_indent = find_minimum_indentation(lines)
    local text_indented = table.concat(
      vim.tbl_map(function(line)
        return line:sub(#min_indent + 1)
      end, lines),
      '\n'
    )

    local trimmed_text = trim_string(text_indented)

    vim.fn.setreg('"', trimmed_text)

    vim.api.nvim_exec_autocmds('TextYankPost', {
      pattern = '*',
      modeline = false,
      data = {
        _yanka = true,
        operator = 'y',
        regcontents = { trimmed_text },
        regname = '"',
        regtype = 'v',
      },
    })
  end,
})
