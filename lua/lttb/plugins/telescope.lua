local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvim-telescope/telescope.nvim',
    keys = function()
      local res = nil
      local function get()
        if res then
          return res
        end

        res = {}
        res.builtin = require('telescope.builtin')
        res.telescope_themes = require('telescope.themes')
        return res
      end

      return {
        {
          '<D-f>',
          function()
            get().builtin.current_buffer_fuzzy_find({
              layout_strategy = 'vertical',
              layout_config = {
                prompt_position = 'top',
              },
            })
          end,
          desc = 'Fuzzily search in current buffer',
        },

        -- {
        --   '<S-D-f>',
        --   function()
        --     builtin.live_grep({
        --       dynamic_preview_title = true,

        --       glob_pattern = {
        --         '!lazy-lock.json',
        --         '!.lock',
        --         '!package-lock.json',
        --         '!LICENSE',
        --       },

        --       layout_strategy = 'vertical',
        --       layout_config = {
        --         prompt_position = 'top',
        --       },
        --     })
        --   end,
        --   desc = 'Search by Grep',
        -- },

        {
          '<D-o>',
          function()
            get().builtin.buffers({
              sort_mru = true,
              ignore_current_buffer = true,
            })
          end,
          desc = 'Search Buffers',
        },

        -- {
        --   '<D-p>',
        --   function()
        --     vim.fn.system('git rev-parse --is-inside-work-tree')
        --
        --     if vim.v.shell_error == 0 then
        --       get().builtin.git_files({
        --         show_untracked = true,
        --       })
        --     else
        --       get().builtin.find_files({})
        --     end
        --   end,
        --   desc = 'Search Files',
        -- },

        -- {
        --   '<leader>sgt',
        --   function()
        --     local type_filter = vim.fn.input('Filetype: ')

        --     builtin.live_grep({
        --       type_filter = type_filter,
        --     })
        --   end,
        --   desc = 'Search by Grep by Type',
        -- },
        -- {

        --   '<leader>sgf',
        --   function()
        --     local glob_pattern = vim.fn.input('Glob: ')

        --     builtin.live_grep({
        --       glob_pattern = glob_pattern,
        --     })
        --   end,
        --   desc = 'Search by Grep by File glob',
        -- },

        -- {
        --   '<leader>sa',
        --   function()
        --     get().builtin.find_files({
        --       hidden = true,
        --       no_ignore = true,
        --     })
        --   end,
        --   desc = 'Search All files',
        -- },

        {
          '<leader>ss',
          function()
            get().builtin.git_files({
              recurse_submodules = true,
            })
          end,
          desc = 'Search Submodules',
        },

        {
          '<leader>sf',
          function()
            require('telescope').extensions.file_browser.file_browser({
              auto_depth = true,
              hidden = false,
              respect_gitignore = true,
              git_status = false,
            })
          end,
          desc = 'Search File Browser',
        },

        {
          '<leader>sc',
          function()
            require('telescope').extensions.file_browser.file_browser({
              path = '%:p:h',
              select_buffer = true,
              auto_depth = true,
              hidden = false,
              respect_gitignore = true,
              git_status = true,
            })
          end,
          desc = 'Search Current File Browser',
        },

        {
          '<leader>sh',
          function()
            get().builtin.help_tags()
          end,
          desc = 'Search Help',
        },
        {
          '<leader>sd',
          function()
            get().builtin.diagnostics()
          end,
          desc = 'Search Diagnostics',
        },
        {
          '<leader>sw',
          function()
            get().builtin.grep_string()
          end,
          desc = 'Search Word',
        },
        -- {
        --   'gs',
        --   function()
        --     get().builtin.lsp_document_symbols()
        --   end,
        --   desc = 'LSP: Goto Symbols',
        -- },

        -- {{{ LSP

        -- {
        --   'gd',
        --   function()
        --     get().builtin.lsp_definitions(get().telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: Goto Definition',
        -- },
        --
        -- {
        --   'gD',
        --   function()
        --     get().builtin.lsp_type_definitions(get().telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: Type Definition',
        -- },
        --
        -- {
        --   'gi',
        --   function()
        --     get().builtin.lsp_implementations(get().telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: Goto Implementation',
        -- },
        --
        -- {
        --   'gr',
        --   function()
        --     get().builtin.lsp_references(get().telescope_themes.get_ivy({
        --       show_line = false,
        --     }))
        --   end,
        --   desc = 'LSP: Goto References',
        -- },

        utils.cmd_shift('p', { '<cmd>Telescope<cr>', desc = 'Telescope' }),

        utils.cmd_shift('r', { '<cmd>Telescope resume<cr>', desc = 'Telescope Resume' }),

        -- }}}
      }
    end,

    opts = function()
      local fb_actions = require('telescope').extensions.file_browser.actions

      return {
        defaults = {
          winblend = 10,

          mappings = {
            i = {
              ['<esc>'] = 'close',
              ['<D-BS>'] = { '<esc>ddi', type = 'command' },
              -- ['<C-h>'] = fb_actions.toggle_hidden,
            },
          },
        },

        extensions = {
          file_browser = {},

          helpgrep = {
            ignore_paths = {
              vim.fn.stdpath('state') .. '/lazy/readme',
            },
          },

          smart_open = {
            match_algorithm = 'fzf',
            disable_devicons = true,
            result_limit = 200,
          },

          frecency = {
            default_workspace = 'CWD',
          },

          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      }
    end,
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
        -- NOTE: it seems it doesn't work with oil.nvim
        enabled = false,
        'dawsers/telescope-file-history.nvim',
        -- NOTE: nice plugin, but spams notifications on changs, need to investigate
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
        enabled = true,
        'lttb/smart-open.nvim',
        branch = 'feat/git-files-open-buffers',
        -- @see https://github.com/danielfalk/smart-open.nvim/issues/43
        -- branch = 'feature/result-bigger-limit',
        -- branch = '0.2.x',
        keys = {
          {
            '<leader><leader>',
            function()
              require('telescope').extensions.smart_open.smart_open({
                cwd_only = true,
                filename_first = false,
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
        enabled = false,
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

      {
        'davvid/telescope-git-grep.nvim',
        branch = 'main',
        config = function()
          require('telescope').load_extension('git_grep')
        end,
      },

      {
        'ahmedkhalf/project.nvim',
        event = 'VeryLazy',
        config = function()
          require('project_nvim').setup({})

          require('telescope').load_extension('projects')
        end,
      },
    },
  },
}
