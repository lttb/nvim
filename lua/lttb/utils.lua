local M = {}

function M.hl_create(group)
  vim.api.nvim_set_hl(0, group, require('lttb.theme').current[group])
end

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

function M.keyplug(name, command, opts)
  vim.keymap.set('', '<Plug>(' .. name .. ')', command, opts)
end

function M.keymap(mode, keys, command, opts, precmd)
  local options = { silent = true }

  if type(keys) ~= 'table' then
    keys = { keys }
  end

  if opts then
    options = vim.tbl_extend('force', options, opts)
  end

  for _, value in pairs(keys) do
    if command:find('^lttb-') then
      vim.keymap.set(mode, value, (precmd or '') .. '<Plug>(' .. command .. ')', options)
    else
      vim.keymap.set(mode, value, command, options)
    end
  end
end

function M.nkeymap(mode, keys, command, opts)
  M.keymap(mode, keys, command, opts, '<C-\\><C-n>')
end

-- @see https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
function M.should_open_sidebar(data)
  local IGNORED_FT = {
    'gitcommit',
    'gitrebase',
  }

  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

  -- &ft
  local filetype = vim.bo[data.buf].ft

  -- only files please
  -- if not real_file and not no_name then
  --   return
  -- end

  -- skip ignored filetypes
  if vim.tbl_contains(IGNORED_FT, filetype) then
    return false
  end

  return true
end

return M
