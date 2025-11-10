-- @see https://github.com/lewis6991/hover.nvim/blob/3b49066e09e03e63be6d6f43ae2b8bcd58301f63/lua/hover/util.lua#L167

local api = vim.api

local M = {}

local BORDER_WIDTHS = {
  none = 0,
  single = 2,
  double = 2,
  rounded = 2,
  solid = 2,
  shadow = 1,
}

local function invalid_border(border)
  return ('invalid floating preview border: %s. :help vim.api.nvim_open_win()'):format(vim.inspect(border))
end

--- @param opts Hover.float_config
--- @return integer
local function get_border_width(opts)
  local border = opts.border or vim.opt.winborder:get()

  if type(border) == 'string' then
    if not BORDER_WIDTHS[border] then
      error(invalid_border(border))
    end
    return BORDER_WIDTHS[border]
  elseif 8 % #border ~= 0 then
    error(invalid_border(border))
  end

  ---@param id integer
  ---@return integer
  local function border_width(id)
    id = (id - 1) % #border + 1
    local part = border[id]
    if type(part) == 'table' then
      --- @cast part [string, string]
      -- border specified as a table of <character, highlight group>
      return vim.fn.strdisplaywidth(part[1])
    elseif type(part) == 'string' then
      -- border specified as a list of border characters
      return vim.fn.strdisplaywidth(part)
    end
    error(invalid_border(border))
  end

  return border_width(4 --[[right]]) + border_width(8 --[[left]])
end

--- @param contents string[]
--- @param opts Hover.float_config
--- @return integer width
--- @return integer height
function M.make_floating_popup_size(contents, opts)
  opts = opts or {}

  local width = opts.width
  local height = opts.height
  local wrap_at = opts._wrap_at
  local max_width = opts.max_width
  local max_height = opts.max_height
  local line_widths = {} --- @type table<integer,integer>

  if not width then
    width = 1 -- not zero, avoid modulo by zero if content is empty
    for i, line in ipairs(contents) do
      line_widths[i] = vim.fn.strdisplaywidth(line)
      width = math.max(line_widths[i], width)
    end
  end

  local border_width = get_border_width(opts)
  local screen_width = api.nvim_win_get_width(0)
  width = math.min(width, screen_width)

  -- make sure borders are always inside the screen
  if width + border_width > screen_width then
    width = width - (width + border_width - screen_width)
  end

  if wrap_at and wrap_at > width then
    wrap_at = width
  end

  if max_width then
    width = math.min(width, max_width)
    wrap_at = math.min(wrap_at or max_width, max_width)
  end

  if not height then
    height = #contents
    if wrap_at and width >= wrap_at then
      height = 0
      if vim.tbl_isempty(line_widths) then
        for _, line in ipairs(contents) do
          local line_width = vim.fn.strdisplaywidth(line)
          height = height + math.ceil(line_width / wrap_at)
        end
      else
        for i = 1, #contents do
          height = height + math.max(1, math.ceil(line_widths[i] / wrap_at))
        end
      end
    end
  end
  if max_height then
    height = math.min(height, max_height)
  end

  return width, math.max(1, height)
end

return M
