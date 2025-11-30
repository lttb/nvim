local M = {}

M.theme = 'morningstar'

function M.hl_create(group)
  vim.api.nvim_set_hl(0, group, require('lttb.theme').current[group])
end

function M.is_ghostty()
  return vim.env.TERM == 'xterm-ghostty' and (not M.is_neovide())
end

function M.is_kitty()
  return vim.env.TERM == 'xterm-kitty' and (not M.is_neovide())
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

function M.is_dotfiles()
  return os.getenv('DOTFILES') == '1'
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
  local args = vim.fn.argv()

  if #args > 0 then
    return
  end

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
  if not real_file or no_name then
    return
  end

  -- skip ignored filetypes
  if vim.tbl_contains(IGNORED_FT, filetype) then
    return false
  end

  return true
end

-- the cmd+shift mapping behaviour is different in kitty/neovide
-- @see https://github.com/neovide/neovide/issues/1237#issuecomment-1912243657
function M.cmd_shift(key, opts)
  if M.is_kitty() or M.is_ghostty() then
    return { '<S-D-' .. string.lower(key) .. '>', unpack(opts) }
  end

  return { '<D-' .. string.upper(key) .. '>', unpack(opts) }
end

-- @see https://github.com/LazyVim/LazyVim/blob/41f40b73d94f12cd6aa2d87bfee8808e76e80d5d/lua/lazyvim/util/init.lua#L153-L174
function M.is_loaded(name)
  local Config = require('lazy.core.config')
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

function M.pad_lines(lines, pad_top, pad_bottom, pad_left, pad_right)
  local padded = {}
  for _ = 1, pad_top do
    table.insert(padded, '')
  end
  for _, line in ipairs(lines) do
    table.insert(padded, string.rep(' ', pad_left) .. line .. string.rep(' ', pad_right))
  end
  for _ = 1, pad_bottom do
    table.insert(padded, '')
  end
  return padded
end

return M
