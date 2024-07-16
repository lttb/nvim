local M = {}

function M.is_kitty()
  return vim.env.KITTY_WINDOW_ID ~= nil and (not M.is_neovide())
end

function M.is_vscode()
  return vim.g.vscode ~= nil
end

function M.is_neovide()
  return vim.g.neovide ~= nil
end

function M.is_goneovim()
  return vim.g.goneovim ~= nil
end

function M.log(v)
  print(vim.inspect(v))
  return v
end
