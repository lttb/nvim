-- vim:fileencoding=utf-8:foldmethod=marker

vim.loader.enable()

local utils = require('lttb.utils')

vim.o.background = vim.env.THEME_MODE or 'light'
vim.env.DELTA_FEATURES = '+' .. vim.o.background

require('lttb.settings')
require('lttb.config.autocmd')
require('lttb.config.keymaps')

require('lttb.config.lazy')

if utils.is_vscode() then
  require('lttb.settings.vscode')

  return
end

vim.cmd.colorscheme(utils.theme)

if utils.is_neovide() then
  require('lttb.settings.neovide')

  return
end

if utils.is_goneovim() then
  require('lttb.settings.goneovim')

  return
end
