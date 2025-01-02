local M = {}

function M.number_to_hex(color)
  return string.format('#%06x', color)
end

function M.rgb_to_hex(r, g, b)
  return string.format('#%02X%02X%02X', r, g, b)
end

function M.blend(from, to, level)
  return M.rgb_to_hex((from.r - to.r) * level + to.r, (from.g - to.g) * level + to.g, (from.b - to.b) * level + to.b)
end

function M.blend_hex(from, to, level)
  local rgb_convert = require('lush.vivid.rgb.convert')

  if to == nil or from == nil then
    return from
  end

  return M.blend(rgb_convert.hex_to_rgb(M.number_to_hex(from)), rgb_convert.hex_to_rgb(M.number_to_hex(to)), level)
end

function M.alpha(from, level)
  local normalHL = vim.api.nvim_get_hl(0, { name = 'Normal' })
  -- support transparent background
  local floatHL = vim.api.nvim_get_hl(0, { name = 'CursorLine' })

  return M.blend_hex(from, normalHL.bg or floatHL.bg, level)
end

function M.get_hl(hl_name, color_name)
  return vim.api.nvim_get_hl(0, { name = hl_name })[color_name]
end

function M.alpha_hl(hl_name, color_name, level, fallback)
  local hl = vim.api.nvim_get_hl(0, { name = hl_name })

  return M.alpha(hl[color_name] or fallback, level)
end

function M.extend_hl(hl_name, opts)
  local hl = vim.api.nvim_get_hl(0, { name = hl_name })

  vim.api.nvim_set_hl(0, hl_name, vim.tbl_extend('force', hl, opts))
end

function M.inherit_hl(hl_name, hl_new_name, opts)
  local hl = vim.api.nvim_get_hl(0, { name = hl_name })

  vim.api.nvim_set_hl(0, hl_new_name, vim.tbl_extend('force', hl, opts))
end

-- function M.extend_hl_alpha(hl, hl_extend, color_name, a, opts)
--   local hlExtendHL = vim.api.nvim_get_hl(0, { name = hl_extend })
--   local currentHL = vim.api.nvim_get_hl(0, { name = hl })

--   vim.api.nvim_set_hl(
--     0,
--     hl,
--     vim.tbl_extend('force', {
--       bg = M.alpha(hlExtendHL[color_name], a),
--       fg = currentHL.fg,
--     }, opts or {})
--   )
-- end

return M
