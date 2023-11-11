local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvim-telescope/telescope.nvim',
    keys = function()
      local builtin = require('telescope.builtin')
      local telescope_themes = require('telescope.themes')

      return {
        { '<S-D-p>', '<cmd>Telescope<cr>', desc = 'Telescope' },
        -- NOTE: support for neovide, @see https://github.com/neovide/neovide/issues/1237
        { '<S-M-p>', '<S-D-p>',            remap = true },

        {
          '<D-f>',
          function()
            builtin.current_buffer_fuzzy_find()
          end,
          desc = 'Fuzzily search in current buffer',
        },

        {
          '<S-D-f>',
          function()
            builtin.live_grep({
              dynamic_preview_title = true,

              glob_pattern = {
                '!lazy-lock.json',
                '!.lock',
                '!package-lock.json',
                '!LICENSE',
              },
            })
          end,
          desc = 'Search by Grep',
        },
        -- NOTE: support for neovide, @see https://github.com/neovide/neovide/issues/1237
        { '<S-M-f>', '<S-D-f>',                   remap = true },

        {
          '<D-o>',
          function()
            builtin.buffers({
              sort_mru = true,
              ignore_current_buffer = true,
            })
          end,
          desc = 'Search Buffers',
        },

        {
          '<D-p>',
          function()
            vim.fn.system('git rev-parse --is-inside-work-tree')

            if vim.v.shell_error == 0 then
              builtin.git_files({
                show_untracked = true,
              })
            else
              builtin.find_files({})
            end
          end,
          desc = 'Search Files',
        },

        { '<D-r>',   '<cmd>Telescope resume<cr>', desc = 'Telescope Resume' },

        {
          '<leader>sgt',
          function()
            local type_filter = vim.fn.input('Filetype: ')

            builtin.live_grep({
              type_filter = type_filter,
            })
          end,
          desc = 'Search by Grep by Type',
        },
        {

          '<leader>sgf',
          function()
            local glob_pattern = vim.fn.input('Glob: ')

            builtin.live_grep({
              glob_pattern = glob_pattern,
            })
          end,
          desc = 'Search by Grep by File glob',
        },

        {
          '<leader>sa',
          function()
            builtin.find_files({
              hidden = true,
              no_ignore = true,
            })
          end,
          desc = 'Search All files',
        },

        {
          '<leader>ss',
          function()
            builtin.git_files({
              recurse_submodules = true,
            })
          end,
          desc = 'Search Submodules',
        },

        { '<leader>sh', builtin.help_tags,            desc = 'Search Help' },
        { '<leader>sd', builtin.diagnostics,          desc = 'Search Diagnostics' },
        { '<leader>sw', builtin.grep_string,          desc = 'Search Word' },
        { 'gs',         builtin.lsp_document_symbols, desc = 'LSP: Goto Symbols' },

        -- {{{ LSP

        {
          'gd',
          function()
            builtin.lsp_definitions(telescope_themes.get_ivy({
              show_line = false,
            }))
          end,
          desc = 'LSP: Goto Definition',
        },

        {
          'gD',
          function()
            builtin.lsp_type_definitions(telescope_themes.get_ivy({
              show_line = false,
            }))
          end,
          desc = 'LSP: Type Definition',
        },

        {
          'gi',
          function()
            builtin.lsp_implementations(telescope_themes.get_ivy({
              show_line = false,
            }))
          end,
          desc = 'LSP: Goto Implementation',
        },

        {
          'gr',
          function()
            builtin.lsp_references(telescope_themes.get_ivy({
              show_line = false,
            }))
          end,
          desc = 'LSP: Goto References',
        },

        -- }}}
      }
    end,

    opts = {
      defaults = {
        winblend = 10,

        mappings = {
          i = {
            ['<esc>'] = 'close',
            ['<D-BS>'] = { '<esc>ddi', type = 'command' },
          },
        },
      },

      extensions = {
        helpgrep = {
          ignore_paths = {
            vim.fn.stdpath('state') .. '/lazy/readme',
          },
        },

        smart_open = {
          match_algorithm = 'fzf',
        },
      },
    },

    config = true,
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
        'nvim-telescope/telescope-file-browser.nvim',
        config = function()
          require('telescope').load_extension('file_browser')
        end,
      },

      {
        'dawsers/telescope-file-history.nvim',
        -- NOTE: nice plugin, but spams notifications on changs, need to investigate
        enabled = false,
        config = function()
          require('file_history').setup()

          require('telescope').load_extension('file_history')
        end,
      },

      {
        'catgoose/telescope-helpgrep.nvim',
        config = function()
          require('telescope').load_extension('helpgrep')
        end,
      },

      {
        'danielfalk/smart-open.nvim',
        enabled = false,
        keys = {
          {
            '<leader><leader>',
            function()
              require('telescope').extensions.smart_open.smart_open({
                cwd_only = true,
              })
            end,
            desc = 'Smart Open',
          },
        },
        config = function()
          require('telescope').load_extension('smart_open')
        end,
        dependencies = { 'kkharji/sqlite.lua' },
      },

      {
        'nvim-telescope/telescope-frecency.nvim',
        config = function()
          require('telescope').load_extension('frecency')
        end,
        keys = {
          {
            '<leader><leader>',
            '<Cmd>Telescope frecency workspace=CWD<CR>',
            desc = 'Smart Open',
          },
        },

      },
    },
  },
}
