local utils = require('lttb.utils')

local config = function()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local builtin = require('telescope.builtin')

  telescope.setup({
    defaults = {
      winblend = 10,

      mappings = {
        i = {
          ['<esc>'] = actions.close,
        },
      },
    },
  })

  -- telescope.load_extension('workspaces')

  utils.keyplug('lttb-telescope', '<cmd>Telescope<cr>')

  utils.keyplug('lttb-find-recent-files', builtin.oldfiles)

  utils.keyplug('lttb-find-buffers', function()
    builtin.buffers({
      sort_mru = true,
      ignore_current_buffer = true,
    })
  end)

  utils.keyplug('lttb-find-all-files', function()
    builtin.find_files({
      hidden = true,
      no_ignore = true,
    })
  end)

  utils.keyplug('lttb-find-files', function()
    vim.fn.system('git rev-parse --is-inside-work-tree')

    if vim.v.shell_error == 0 then
      builtin.git_files({
        show_untracked = true,
      })
    else
      builtin.find_files({})
    end
  end)

  utils.keyplug('lttb-find-files-submodules', function()
    builtin.git_files({
      recurse_submodules = true,
    })
  end)

  utils.keyplug('lttb-search-buffer', function()
    builtin.current_buffer_fuzzy_find()
  end)

  utils.keyplug('lttb-search-grep', builtin.live_grep)

  utils.keyplug('lttb-search-help', builtin.help_tags)

  utils.keyplug('lttb-search-diagnostics', builtin.diagnostics)

  utils.keyplug('lttb-search-current-word', builtin.grep_string)

  utils.keyplug('lttb-lsp-references', builtin.lsp_references)

  utils.keyplug('lttb-lsp-document-symbols', builtin.lsp_document_symbols)

  utils.keyplug(
    'lttb-lsp-workspace-symbols',
    builtin.lsp_dynamic_workspace_symbols
  )
end

return {
  {
    'nvim-telescope/telescope.nvim',
    config = config,
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- @see https://github.com/nvim-telescope/telescope-fzf-native.nvim#cmake-windows-linux-macos
        -- run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        build = 'make',
        config = function()
          require('telescope').load_extension('fzf')
        end,
      },

      {
        'danielfalk/smart-open.nvim',
        config = function()
          require('telescope').load_extension('smart_open')

          utils.keyplug('lttb-smart-open', function()
            require('telescope').extensions.smart_open.smart_open()
          end)
        end,
        dependencies = { 'kkharji/sqlite.lua' },
      },
    },
  },
}
