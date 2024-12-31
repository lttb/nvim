local M = {}

M.config = {
  keys = 'asdfjkl;ghqwertyuiopzxcvbnm',
  popup = {
    border = 'rounded',
    width = 60,
    height = 10,
    row = 1,
    col = 1,
  },
}

local function generate_labels(items)
  local used_keys = {}
  local labels = {}

  for i, item in ipairs(items) do
    local first_char = item:sub(1, 1):lower()
    if not used_keys[first_char] and M.config.keys:find(first_char, 1, true) then
      labels[i] = first_char
      used_keys[first_char] = true
    end
  end

  local key_index = 1
  for i = 1, #items do
    if not labels[i] then
      while key_index <= #M.config.keys do
        local key = M.config.keys:sub(key_index, key_index)
        key_index = key_index + 1
        if not used_keys[key] then
          labels[i] = key
          used_keys[key] = true
          break
        end
      end
    end
  end

  return labels
end

function M.select(items, opts, on_choice)
  local labels = generate_labels(items)
  local selected_index = nil

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = M.config.popup.width,
    height = math.min(#items, M.config.popup.height),
    row = M.config.popup.row,
    col = M.config.popup.col,
    style = 'minimal',
    border = M.config.popup.border,
  })

  local function update_display()
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    local lines = {}
    for i, item in ipairs(items) do
      local line = string.format('%s. %s', labels[i], item)
      if i == selected_index then
        line = '> ' .. line
      else
        line = '  ' .. line
      end
      table.insert(lines, line)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  end

  update_display()
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  vim.defer_fn(function()
    while true do
      local char = vim.fn.getchar()
      if char == 27 then -- Esc key
        on_choice(nil, nil)
        break
      end

      local key = vim.fn.nr2char(char)
      for i, label in ipairs(labels) do
        if key == label then
          if selected_index == i then
            on_choice(items[i], i)
            vim.api.nvim_win_close(win, true)
            return
          else
            selected_index = i
            update_display()
          end
          break
        end
      end
    end

    vim.api.nvim_win_close(win, true)
  end, 0)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

return M
