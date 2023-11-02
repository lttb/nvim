-- vim:fileencoding=utf-8:foldmethod=marker

vim.loader.enable()

require('lttb.settings')
require('lttb.autocmd')

-- {{{ Bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
-- }}}

require('lazy').setup('lttb.plugins')

require('lttb.keymaps')

local utils = require('lttb.utils')

if utils.is_vscode() then
  require('lttb.settings.vscode')

  return
end

local theme = require('lttb.theme')

vim.opt.background = theme.variant
vim.cmd.colorscheme(theme.colorscheme)

if utils.is_neovide() then
  require('lttb.settings.neovide')

  return
end
