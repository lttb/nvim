-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local utils = require("lttb.utils")

local yanka = require("lttb.plugins.yanka")

vim.keymap.set("n", "p", function()
  vim.api.nvim_feedkeys("o", "n", false)
  vim.schedule(function()
    yanka.put_with_autoindent()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "i", true)
  end)
end)
vim.keymap.set("n", "P", function()
  vim.api.nvim_feedkeys("O", "n", false)
  vim.schedule(function()
    yanka.put_with_autoindent()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "i", true)
  end)
end)

if utils.is_vscode() then
  return
end

require("lttb.plugins.macos-keymaps").setup()

vim.keymap.set("n", "<C-D>", "25j", { desc = "Better Scroll Down" })
vim.keymap.set("n", "<C-U>", "25k", { desc = "Better Scroll Up" })

-- Auto indent on empty line.
vim.keymap.set("n", "i", function()
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "i"
end, { expr = true, remap = false })

-- More granular undo in insert mode
vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>", { remap = false })
vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>")
vim.keymap.set("i", "<D-z>", "<C-w>")

-- yanka config
vim.keymap.set("x", "<D-x>", '"+d')
vim.keymap.set("n", "<D-x>", '"+dd')
vim.keymap.set("x", "<D-c>", "y")
vim.keymap.set("n", "<D-c>", "yy")
vim.keymap.set({ "i", "n", "t", "x" }, "<D-v>", yanka.put_with_autoindent, { noremap = true, silent = true })
vim.keymap.set("c", "<D-v>", "<C-r>+")
