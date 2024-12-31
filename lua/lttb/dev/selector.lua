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

function M.select(items, opts, on_choice)
  -- Create buffer for popup
  local buf = vim.api.nvim_create_buf(false, true)

  local height_content = #items
  local width_content

  local used_labels = {}

  local function get_label(name, to)
    to = to or 1
    local key = name:sub(1, to):lower():gsub('%W', '')

    if not used_labels[key] then
      used_labels[key] = true
      return key
    end

    return get_label(name, to + 1)
  end

  -- Set buffer options
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })

  local function render()
    width_content = 0

    local format_item = opts.format_item or tostring

    local lines = {}
    for i, item in ipairs(items) do
      local name = format_item(item)

      -- local label = get_label(name)
      local label = '❯'

      local line = string.format('%s %s', label, name)

      line = ' ' .. line:gsub('\r', '')

      table.insert(lines, line)

      width_content = 5 + math.max(width_content, vim.fn.strdisplaywidth(line))
    end

    vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

    -- Clear existing highlights
    vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
  end

  render()

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

    local flash = require('flash')

    vim.keymap.set('n', '<ESC>', function()
      vim.api.nvim_win_close(popup, true)
    end, { buffer = buf, noremap = true, silent = true })

    -- Use flash.nvim for selection
    flash.jump({
      action = function(match, state)
        state:hide()
        local line = match.pos[1]
        on_choice(items[line], line)
        vim.api.nvim_win_close(popup, true)
      end,
      win = popup,
      search = {
        multi_window = false,
        incremental = true,
      },
    })
  end, 0)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

return M
