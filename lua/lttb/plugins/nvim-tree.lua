require('nvim-tree').setup({
  -- disable_netrw = false,
  -- hijack_netrw = false,

  open_on_setup_file = true,
  ignore_ft_on_setup = { 'gitcommit', 'gitrebase' },
  -- respect_buf_cwd = true,
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  prefer_startup_root = true,
  update_focused_file = {
    enable = true,
    update_root = true,
    ignore_list = { 'help' },
  },

  git = {
    enable = true,
  },

  view = {
    width = 50,
    adaptive_size = false,
    mappings = {
      list = {
        {
          key = 's',
          action = nil,
        },
      },
    },
  },
})

local nt_api = require('nvim-tree.api')
local utils = require('lttb.utils')

utils.keyplug('lttb-sidebar-toggle', function()
  nt_api.tree.toggle(true, true)
end)

utils.keyplug('lttb-sidebar-focus', function()
  nt_api.tree.focus()
end)
