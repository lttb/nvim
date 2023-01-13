-- vim:fileencoding=utf-8:foldmethod=marker

require('lttb.settings')

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

local utils = require('lttb.utils')
local theme = require('lttb.theme')

if theme.colorscheme == 'github_light' then
  -- NOTE: for some reason nvim_set_hl didn't override
  vim.api.nvim_set_hl(0, 'TreesitterContext', {
    link = 'CursorLineFold',
    default = false,
    nocombine = true,
  })
  -- vim.cmd('hi! link TreesitterContext CursorLineFold')
end

if utils.is_vscode() then
  require('lttb.settings.vscode')

  return
end

if utils.is_neovide() then
  require('lttb.settings.neovide')

  return
end
