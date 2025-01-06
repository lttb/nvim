local M = {}

M.config = {
  popup = {
    border = 'rounded',
    width = 60,
    height = 10,
  },
}

function M.select(items, opts, on_choice)
  local buf = vim.api.nvim_create_buf(false, true)
  local height_content = #items
  local width_content

  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })

  local prev_index = 1
  local current_index = 1
  local lines = {}

  local selected_char = vim.api.nvim_replace_termcodes('❯', true, true, true)

  local function render()
    width_content = 0
    local format_item = opts.format_item or tostring
    for i, item in ipairs(items) do
      local name = format_item(item)
      local prefix = i == current_index and selected_char or ' '
      local line = string.format('%s %s', prefix, name):gsub('\r', '')
      table.insert(lines, line)
      width_content = 5 + math.max(width_content, vim.fn.strdisplaywidth(line))
    end

    vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  end

  local function update()
    local selected = selected_char .. ' '
    local unselected = '  '
    vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
    vim.api.nvim_buf_set_text(buf, prev_index - 1, 0, prev_index - 1, #selected, { unselected })
    vim.api.nvim_buf_set_text(buf, current_index - 1, 0, current_index - 1, #unselected, { selected })
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  end

  render()

  local width = width_content or M.config.popup.width
  local height = math.min(height_content, M.config.popup.height)

  vim.defer_fn(function()
    local popup = vim.api.nvim_open_win(buf, true, {
      relative = 'cursor',
      row = 1,
      col = 0,
      width = width,
      height = height,
      style = 'minimal',
      border = M.config.popup.border,
      zindex = 1000,
    })

    local function close_popup()
      vim.api.nvim_win_close(popup, true)
    end

    local function move_cursor(delta)
      prev_index = current_index
      current_index = (current_index + delta - 1) % #items + 1
      update()
      vim.api.nvim_win_set_cursor(popup, { current_index, 0 })
    end

    local function move_up()
      move_cursor(-1)
    end
    local function move_down()
      move_cursor(1)
    end
    local function confirm()
      on_choice(items[current_index], current_index)

      vim.api.nvim_input('<esc>')
    end

    local flash = require('flash')

    vim.keymap.set('n', '<Down>', move_down, { buffer = buf, remap = false, silent = true })

    vim.keymap.set('n', '<Up>', move_up, { buffer = buf, remap = false, silent = true })

    vim.keymap.set('n', '<CR>', confirm, { buffer = buf, noremap = true, silent = true })

    vim.keymap.set('n', '<ESC>', close_popup, { buffer = buf, noremap = true, silent = true })

    local DOWN = vim.api.nvim_replace_termcodes('<Down>', true, true, true)
    local UP = vim.api.nvim_replace_termcodes('<Up>', true, true, true)
    local CR = vim.api.nvim_replace_termcodes('<CR>', true, true, true)

    flash.jump({
      action = function(match, state)
        state:hide()
        local line = match.pos[1]
        on_choice(items[line], line)
        close_popup()
      end,
      win = buf,
      search = {
        multi_window = false,
        incremental = true,
        mode = 'search',
      },
      actions = {
        [CR] = function(state)
          state:hide()
          confirm()
        end,
        [DOWN] = move_down,
        [UP] = move_up,
      },
    })
  end, 0)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})

  vim.ui.select = M.select
end

return M
