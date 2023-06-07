local theme = require('lttb.theme')

-- vim.opt.guifont = {
--   'Fira Code',
--   ':h20',
--   ':#e-antialias',
--   -- ':#h-full',
-- }

vim.opt.guifont = 'Fira Code:h15:#e-subpixelantialias:#h-none'

if theme.colorscheme == 'github_dark' then
  vim.g.neovide_background_color = '#23292f'
elseif theme.colorscheme == 'github_light' then
  -- vim.g.neovide_background_color = '#f7f9fb'
  vim.g.neovide_background_color = '#ffffff'
elseif theme.colorscheme == 'catppuccin-frappe' then
  vim.g.neovide_background_color = '#2f3446'
end

vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_fullscreen = false

-- vim.g.neovide_remember_window_size = true
-- vim.g.neovide_remember_window_position = true

vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_input_use_logo = true

-- vim.g.neovide_padding_top = 24
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
-- vim.g.neovide_padding_left = 1

-- vim.opt.linespace = 2

-- vim.g.neovide_profiler = true
-- vim.g.neovide_refresh_rate = 144

-- vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
