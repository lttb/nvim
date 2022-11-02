local theme = require('lttb.theme')

vim.opt.guifont = { 'Fira Code', ':h15.5' }

if theme.variant == 'dark' then
  vim.g.neovide_background_color = '#23292f'
else
  vim.g.neovide_background_color = '#ffffff'
end

vim.g.neovide_fullscreen = false

vim.g.neovide_remember_window_size = true

vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_input_use_logo = true
