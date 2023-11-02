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
          desc = '[Search] by [G]rep',
        },
        {
          '<D-o>',
          function()
            builtin.buffers({
              sort_mru = true,
              ignore_current_buffer = true,
            })
          end,
          desc = '[S]earch [B]uffers',
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
          desc = '[S]earch [F]iles',
        },

        { '<D-r>', '<cmd>Telescope resume<cr>', desc = 'Telescope Resume' },

        {
          '<leader>sgt',
          function()
            local type_filter = vim.fn.input('Filetype: ')

            builtin.live_grep({
              type_filter = type_filter,
            })
          end,
          desc = '[S]earch by [G]rep by [T]ype',
        },
        {

          '<leader>sgf',
          function()
            local glob_pattern = vim.fn.input('Glob: ')

            builtin.live_grep({
              glob_pattern = glob_pattern,
            })
          end,
          desc = '[S]earch by [G]rep by [F]ile glob',
        },

        {
          '<leader>sa',
          function()
            builtin.find_files({
              hidden = true,
              no_ignore = true,
            })
          end,
          desc = '[S]earch [All] files',
        },

        {
          '<leader>ss',
          function()
            builtin.git_files({
              recurse_submodules = true,
            })
          end,
          desc = '[S]earch [S]ubmodules',
        },

        { '<leader>sh', builtin.help_tags, desc = '[S]earch [H]elp' },
        { '<leader>sd', builtin.diagnostics, desc = '[S]earch [D]iagnostics' },
        { '<leader>sw', builtin.grep_string, desc = '[S]earch [W]word' },

        { 'gs', builtin.lsp_document_symbols, desc = 'LSP: [G]oto [S]ymbols' },

        -- {{{ LSP

        -- Covered by LSP keymaps (from lsp-zero)
        -- {
        --   'gd',
        --   function()
        --     builtin.lsp_definitions(telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: [G]oto [D]efinition',
        -- },

        -- {
        --   'gD',
        --   function()
        --     builtin.lsp_type_definitions(telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: Type [D]efinition',
        -- },

        -- {
        --   'gi',
        --   function()
        --     builtin.lsp_implementations(telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: [G]oto [I]mplementation',
        -- },

        -- {
        --   'gr',
        --   function()
        --     builtin.lsp_references(telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: [G]oto [R]eferences',
        -- },
        -- }}}
      }
    end,

    opts = {
      defaults = {
        mappings = {
          i = {
            ['<esc>'] = 'close',
            ['<D-BS>'] = { '<esc>ddi', type = 'command' },
          },
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
        'nvim-telescope/telescope-fzy-native.nvim',
        config = function()
          require('telescope').load_extension('fzy_native')
        end,
      },

      {
        'nvim-telescope/telescope-file-browser.nvim',
        config = function()
          require('telescope').load_extension('file_browser')
        end,
      },

      {
        'danielfalk/smart-open.nvim',
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
    },
  },
}
