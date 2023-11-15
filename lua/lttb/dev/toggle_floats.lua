local utils = require('lttb.utils')

local M = {}

local hidden_w = {}
local last_w = nil

function M.toggle_floats(callback)
  local wins = vim.api.nvim_list_wins()

  -- utils.log(wins)

  if #hidden_w > 0 then
    for _, w in ipairs(hidden_w) do
      vim.api.nvim_win_set_config(w, { hide = false })
    end

    local widest = 0
    local widest_wid

    -- for _, w in ipairs(wins) do
    --   local win_config = vim.api.nvim_win_get_config(w)

    --   print(w)

    --   -- utils.log(win_config)

    --   -- if win_config.width > widest then
    --   --   widest_wid = w
    --   -- end
    -- end

    if last_w then
      vim.api.nvim_set_current_win(last_w)

      vim.schedule(function()
        vim.api.nvim_feedkeys('i', 'n', false)
      end)
    end

    hidden_w = {}
    last_w = nil

    return
  end

  last_w = vim.api.nvim_get_current_win()

  for id, w in ipairs(wins) do
    -- print(_, w)
    local win_config = vim.api.nvim_win_get_config(w)
    -- utils.log(win_config)
    if
      win_config.relative == 'editor'
      -- ignore mini map (TODO: find a better detection way)
      and win_config.zindex ~= 10
    then
      -- utils.log(win_config)
      vim.api.nvim_win_set_config(w, { hide = true })
      table.insert(hidden_w, w)
    end
  end

  vim.opt.eventignore:append('WinLeave')
  vim.opt.eventignore:append('BufLeave')
  vim.api.nvim_set_current_win(1000)

  vim.schedule(function()
    if callback then
      callback()
    end

    vim.opt.eventignore:remove('WinLeave')
    vim.opt.eventignore:remove('BufLeave')
  end)
end

return M
