-- vim:fileencoding=utf-8:foldmethod=marker

vim.loader.enable()

require('lttb.settings')

require('lttb.config.lazy')

require('lttb.config.autocmd')
require('lttb.config.keymaps')

local utils = require('lttb.utils')

if utils.is_vscode() then
  require('lttb.settings.vscode')

  return
end

vim.o.background = 'dark'
vim.cmd.colorscheme('ghostflow')

-- local homerow_select = require('lttb.dev.flash-select')
-- homerow_select.setup({})
-- vim.ui.select = homerow_select.select

if utils.is_neovide() then
  require('lttb.settings.neovide')

  return
end

if utils.is_goneovim() then
  require('lttb.settings.goneovim')

  return
end
