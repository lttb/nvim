local M = {}

function M.setup()
  vim.keymap.set('x', '<BS>', 'd')

  local function native_nav(key, ncmd, icmd, xcmd)
    vim.keymap.set('n', key, ncmd, { remap = true })
    vim.keymap.set(
      'i',
      key,
      '<cmd>set eventignore=InsertLeave<cr><esc>' .. key .. '<cmd>set eventignore=""<cr>' .. (icmd or ''),
      { remap = true }
    )
    if xcmd then
      vim.keymap.set('x', key, xcmd, { remap = true })
    end
  end

  local wm = ''

  native_nav('<M-BS>', 'l"_db', 'i')
  native_nav('<M-DEL>', wm .. 'e"_da' .. wm .. 'w', 'i')

  native_nav('<S-Left>', 'vh', '', 'h')
  native_nav('<S-Right>', 'vl', '', 'l')
  native_nav('<S-Up>', 'vk', '', 'k')
  native_nav('<S-Down>', 'vj', '', 'j')

  native_nav('<M-Left>', wm .. 'b', 'i')
  native_nav('<M-Right>', wm .. 'e', 'a')

  native_nav('<M-S-Left>', wm .. 'ev' .. wm .. 'b', '', ',b')
  native_nav('<M-S-Right>', 'vi' .. wm .. 'e', '', ',w')
end

return M
