local M = {}

M.config = {
  keys = 'asdfjkl;ghqwertyuiopzxcvbnm',
  popup = {
    border = 'rounded',
    width = 60,
    height = 10,
  },
  highlight_group = 'PmenuSel',
}

local function generate_labels(items)
  local used_keys = {}
  local labels = {}

  for i, item in ipairs(items) do
    local first_char = tostring(item):sub(1, 1):lower()
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
  local selected_index = nil

  -- Create buffer for popup
  local buf = vim.api.nvim_create_buf(false, true)


  local height_content = #items
  local width_content

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)

  local keys = {}
  M.config.keys:gsub('.', function(c) table.insert(keys, c) end)
  local labels = {}
  local used_keys = {}

  local function update_display()
    width_content = 0

    local format_item = opts.format_item or tostring
    local lines = {}
    for i, item in ipairs(items) do
      local name = format_item(item)
      local first_char = name:sub(1, 1):lower()

      local line = string.format('%s. %s', labels[i], name)

      line = ' ' .. line:gsub('\r', '')

      if i == selected_index then
        line = '> ' .. line
      else
        line = '  ' .. line
      end

      table.insert(lines, line)

      width_content = math.max(width_content, vim.fn.strdisplaywidth(line))

      print(line)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Clear existing highlights
    vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)

    -- Apply highlight to the selected item
    if selected_index then
      vim.api.nvim_buf_add_highlight(buf, -1, M.config.highlight_group, selected_index - 1, 0, -1)
    end
  end

  update_display()

  -- Calculate dimensions
  local width = width_content or M.config.popup.width
  local height = math.min(height_content, M.config.popup.height)

  -- Handle input
  vim.defer_fn(function()
    -- Create popup window
    local popup = vim.api.nvim_open_win(buf, true, {
      relative = 'cursor',
      row = 1,
      col = 0,
      width = width,
      height = height,
      style = 'minimal',
      border = M.config.popup.border,
    })

    while true do
      local char = vim.fn.getchar()
      if char == 27 then -- Esc key
        on_choice(nil, nil)
        break
      end

      local key = vim.fn.nr2char(char)

      local selected_item = labels[key]

      if selected_item == nil then
        goto continue
      end

      if selected_index then
        on_choice(items[selected_index], selected_index)
        vim.api.nvim_win_close(popup, true)
      end

      selected_index = selected_item.index
      update_display()

      ::continue::
    end

    vim.api.nvim_win_close(popup, true)
  end, 0)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

return M
