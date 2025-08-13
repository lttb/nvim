-- vim:fileencoding=utf-8:foldmethod=marker

vim.loader.enable()

vim.o.background = vim.env.THEME_MODE or 'light'

require('lttb.settings')

require('lttb.config.lazy')

require('lttb.config.autocmd')
require('lttb.config.keymaps')

local utils = require('lttb.utils')

if utils.is_vscode() then
  require('lttb.settings.vscode')

  return
end

vim.cmd.colorscheme('github-monochrome')

if utils.is_neovide() then
  require('lttb.settings.neovide')

  return
end

if utils.is_goneovim() then
  require('lttb.settings.goneovim')

  return
end
