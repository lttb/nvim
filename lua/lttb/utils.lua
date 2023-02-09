local M = {}

function M.hl_create(group)
  vim.api.nvim_set_hl(0, group, require('lttb.theme').current[group])
end

function M.is_kitty()
  return vim.env.KITTY_WINDOW_ID ~= nil
end

function M.is_vscode()
  return vim.g.vscode ~= nil
end

function M.is_neovide()
  return vim.g.neovide ~= nil
end

function M.log(v)
  print(vim.inspect(v))
  return v
end

function M.keyplug(name, command, opts)
  vim.keymap.set('', '<Plug>(' .. name .. ')', command, opts)
end

function M.keymap(mode, keys, command, opts)
  local options = { silent = true }

  if type(keys) ~= 'table' then
    keys = { keys }
  end

  if opts then
    options = vim.tbl_extend('force', options, opts)
  end

  for _, value in pairs(keys) do
    vim.keymap.set(mode, value, (mode == 'i' and '<C-\\><C-n>' or '') .. '<Plug>(' .. command .. ')', options)
  end
end

return M
