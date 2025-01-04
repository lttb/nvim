local M = {}

-- Table to track windows with sync enabled
local synced_windows = {}

-- Custom nvim_open_win function
function M.open_win(buffer, enter, base_options, options)
  -- Extract width-related options
  local width = options.width
  local min_width = options.min_width or 0
  local max_width = options.max_width or math.huge

  -- Calculate dynamic width if width is between 0 and 1
  if width > 0 and width <= 1 then
    local total_width = vim.o.columns
    width = math.floor(total_width * width)
    -- Apply min_width and max_width constraints
    width = math.max(width, min_width)
    width = math.min(width, max_width)
  end

  -- Call the original nvim_open_win function with updated options
  local win_id = vim.api.nvim_open_win(buffer, enter, vim.tbl_extend('keep', { width = width }, base_options))

  -- If sync is enabled, track the window for resizing on screen changes
  if options.sync then
    synced_windows[win_id] = {
      buffer = buffer,
      width = width,
      base_options = base_options,
      options = vim.tbl_extend('force', options, { sync = nil }), -- Remove sync to avoid recursion
    }
  end

  return win_id
end

-- Function to resize synced windows on VimResized event
function M.resize_synced_windows()
  for win_id, data in pairs(synced_windows) do
    if vim.api.nvim_win_is_valid(win_id) then
      -- Recalculate dynamic width for the window
      local total_width = vim.o.columns
      local width = data.options.width

      if width > 0 and width <= 1 then
        width = math.floor(total_width * width)
        -- Apply min_width and max_width constraints
        width = math.max(width, data.options.min_width or 0)
        width = math.min(width, data.options.max_width or math.huge)
      end

      synced_windows[win_id].width = width

      -- Update the window configuration with the new width
      vim.api.nvim_win_set_config(win_id, vim.tbl_extend('keep', { width = width }, data.base_options))
    else
      -- Remove invalid windows from tracking table
      synced_windows[win_id] = nil
    end
  end
end

function M.get_win_width(winid)
  return synced_windows[winid] and synced_windows[winid].width
end

local is_set = false

function M.setup()
  if is_set then
    return
  end

  -- Autocommand to handle VimResized event for synced windows
  vim.api.nvim_create_autocmd('VimResized', {
    callback = M.resize_synced_windows,
  })

  is_set = true
end

return M
