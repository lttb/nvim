local M = {}

function M.hl_create(group)
  vim.api.nvim_set_hl(0, group, require('lttb.theme').current[group])
end

function M.is_vscode()
  return vim.g.vscode ~= nil
end

function M.log(v)
  print(vim.inspect(v))
  return v
end

return M
