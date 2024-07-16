-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local utils = require("utils")

if utils.is_vscode() then
  return
end

-- vim.api.nvim_create_autocmd({ "BufReadPre" }, {
--   callback = function()
--     -- ignore zen-mode if files opened directly
--     if next(vim.fn.argv()) ~= nil then
--       return
--     end
--
--     local zen_mode = require("zen-mode")
--
--     zen_mode.open()
--   end,
-- })
