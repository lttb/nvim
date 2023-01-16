local function config()
  local nvim_tree = require('nvim-tree')

  nvim_tree.setup({
    -- disable_netrw = false,
    -- hijack_netrw = false,

    open_on_setup = true,
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

    remove_keymaps = {
      's',
    },

    git = {
      enable = true,
    },

    view = {
      width = 50,
      adaptive_size = false,
      mappings = {
        list = {
          { key = { '<LeftRelease>' }, action = 'preview' },
        },
      },
    },

    renderer = {
      highlight_opened_files = 'icon',
      highlight_modified = 'name',

      icons = {
        git_placement = 'after',
        modified_placement = 'after',
      },
    },

    diagnostics = {
      enable = true,
      show_on_dirs = true,
      severity = {
        min = vim.diagnostic.severity.ERROR,
      },
    },

    modified = {
      enable = true,
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
end

return {
  {
    'kyazdani42/nvim-tree.lua',
    config = config,
    enabled = not require('lttb.utils').is_vscode(),
  },
}
