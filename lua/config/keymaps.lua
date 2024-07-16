-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local utils = require("lttb.utils")

if utils.is_vscode() then
  return
end

require("lttb.plugins.macos-keymaps").setup()
