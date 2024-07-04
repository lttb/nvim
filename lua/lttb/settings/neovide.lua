local theme = require('lttb.theme')

-- vim.opt.guifont = {
--   'Fira Code',
--   ':h20',
--   ':#e-antialias',
--   -- ':#h-full',
-- }

vim.opt.guifont = 'JetBrains Mono:h15:w0.5:#h-slight'
vim.opt.linespace = 6

vim.g.neovide_window_blurred = true
vim.g.neovide_transparency = 0.95

vim.g.neovide_floating_blur_amount_x = 30
vim.g.neovide_floating_blur_amount_y = 30

vim.g.neovide_underline_stroke_scale = 1.2

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

vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
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

vim.g.neovide_text_gamma = 1.7
vim.g.neovide_text_contrast = 0.3
