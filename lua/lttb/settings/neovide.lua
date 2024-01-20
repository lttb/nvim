local theme = require('lttb.theme')

-- vim.opt.guifont = {
--   'Fira Code',
--   ':h20',
--   ':#e-antialias',
--   -- ':#h-full',
-- }

vim.opt.guifont = 'Fira Code:h14:w0.5:#h-slight'
vim.opt.linespace = 6

if theme.colorscheme == 'github_dark' then
  vim.g.neovide_background_color = '#23292f'
elseif theme.colorscheme == 'github_light' then
  -- vim.g.neovide_background_color = '#f7f9fb'
  vim.g.neovide_background_color = '#ffffff'
elseif theme.colorscheme == 'catppuccin-frappe' then
  vim.g.neovide_background_color = '#2f3446'
elseif theme.colorscheme == 'kanagawa' then
  vim.g.neovide_background_color = '#1b1b1b'
elseif theme.colorscheme == 'zenwritten' then
  vim.g.neovide_background_color = '#191919'
elseif theme.colorscheme == 'zengithub' and theme.variant == 'light' then
  vim.g.neovide_background_color = '#FAFAFA'
elseif theme.colorscheme == 'zengithub' and theme.variant == 'dark' then
  vim.g.neovide_background_color = '#24282e'
elseif theme.variant == 'light' and theme.name == 'rose-pine' then
  vim.g.neovide_background_color = '#faf4ed'
elseif theme.variant == 'dark' and theme.name == 'rose-pine' then
  vim.g.neovide_background_color = '#191724'
elseif theme.variant == 'light' then
  vim.g.neovide_background_color = '#ffffff'
end

vim.g.neovide_floating_blur_amount_x = 30
vim.g.neovide_floating_blur_amount_y = 30

vim.g.neovide_fullscreen = false

-- vim.g.neovide_transparency = 0.0
-- could be more transparent with blur support
-- @see https://github.com/neovide/neovide/pull/2104
-- vim.g.transparency = 1

-- local alpha = function()
--   return string.format('%x', math.floor(255 * vim.g.transparency or 0.9))
-- end

-- vim.g.neovide_background_color = vim.g.neovide_background_color .. alpha()

-- vim.g.neovide_remember_window_size = true
-- vim.g.neovide_remember_window_position = true

vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_input_use_logo = true

-- in case of buttonless frame

-- vim.g.neovide_padding_top = 20
-- vim.g.neovide_padding_bottom = 20
-- vim.g.neovide_padding_right = 20
-- vim.g.neovide_padding_left = 20

-- vim.g.neovide_profiler = true
-- @see https://github.com/neovide/neovide/issues/2093
-- vim.g.neovide_refresh_rate = 144

vim.g.neovide_cursor_vfx_mode = 'pixiedust'

vim.g.neovide_floating_shadow = false
