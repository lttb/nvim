local theme = require('lttb.theme')

-- vim.opt.guifont = {
--   'Fira Code',
--   ':h20',
--   ':#e-antialias',
--   -- ':#h-full',
-- }

vim.opt.guifont = 'Fira Code:h15:w1:#e-subpixelantialias:#h-slight'
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
  vim.g.neovide_background_color = '#EFF1F5'
elseif theme.colorscheme == 'zengithub' and theme.variant == 'dark' then
  vim.g.neovide_background_color = '#22272e'
elseif theme.variant == 'light' then
  vim.g.neovide_background_color = '#ffffff'
end

vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_fullscreen = false

-- vim.g.neovide_remember_window_size = true
-- vim.g.neovide_remember_window_position = true

vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_input_use_logo = true

vim.keymap.set('x', '<D-x>', '"+d')                -- cut
vim.keymap.set('x', '<D-c>', '"+y')                -- copy
vim.keymap.set('i', '<D-v>', '<C-r><C-p>+')        -- paste (insert)
vim.keymap.set('n', '<D-v>', 'i<C-r><C-p>+<ESC>l') -- paste (normal)
vim.keymap.set('x', '<D-v>', '"+P')                -- paste (visual)
vim.keymap.set('c', '<D-v>', '<C-r>+')             -- paste (command)

-- in case of buttonless frame

vim.g.neovide_padding_top     = 20
vim.g.neovide_padding_bottom  = 20
vim.g.neovide_padding_right   = 20
vim.g.neovide_padding_left    = 20

-- vim.g.neovide_profiler = true
-- @see https://github.com/neovide/neovide/issues/2093
vim.g.neovide_refresh_rate    = 144

vim.g.neovide_cursor_vfx_mode = 'pixiedust'
