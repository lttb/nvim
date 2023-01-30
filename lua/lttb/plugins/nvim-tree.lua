local utils = require('lttb.utils')

local function config()
  local nvim_tree = require('nvim-tree')

  nvim_tree.setup({
    -- disable_netrw = false,
    -- hijack_netrw = false,

    -- ignore_ft_on_setup = { 'gitcommit', 'gitrebase' },
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

  utils.keyplug('lttb-sidebar-toggle', function()
    nt_api.tree.toggle(true, true)
  end)

  utils.keyplug('lttb-sidebar-focus', function()
    nt_api.tree.focus()
  end)

  -- @see https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
  local function open_nvim_tree(data)
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
    if not real_file and not no_name then
      return
    end

    -- skip ignored filetypes
    if vim.tbl_contains(IGNORED_FT, filetype) then
      return
    end

    -- open the tree but don't focus it
    require('nvim-tree.api').tree.toggle({ focus = false })
  end

  vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
end

if utils.is_vscode() then
  return {}
end

return {
  {
    'kyazdani42/nvim-tree.lua',
    config = config,
  },
}
