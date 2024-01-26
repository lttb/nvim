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

        {
          '<D-f>',
          function()
            builtin.current_buffer_fuzzy_find({
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
        --     builtin.find_files({
        --       hidden = true,
        --       no_ignore = true,
        --     })
        --   end,
        --   desc = 'Search All files',
        -- },

        -- {
        --   '<leader>ss',
        --   function()
        --     builtin.git_files({
        --       recurse_submodules = true,
        --     })
        --   end,
        --   desc = 'Search Submodules',
        -- },

        -- { '<leader>sh', builtin.help_tags, desc = 'Search Help' },
        { '<leader>sd', builtin.diagnostics, desc = 'Search Diagnostics' },
        { '<leader>sw', builtin.grep_string, desc = 'Search Word' },
        { 'gs', builtin.lsp_document_symbols, desc = 'LSP: Goto Symbols' },

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

        utils.cmd_shift('p', { '<cmd>Telescope<cr>', desc = 'Telescope' }),

        utils.cmd_shift('r', { '<cmd>Telescope resume<cr>', desc = 'Telescope Resume' }),

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

        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
      },
    },

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
        'lttb/smart-open.nvim',
        -- @see https://github.com/danielfalk/smart-open.nvim/issues/43
        branch = 'feature/result-limit',
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
        'nvim-telescope/telescope-frecency.nvim',
        enabled = false,
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
    },
  },

  {
    'windwp/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local spectre = require('spectre')

      spectre.setup({
        live_update = true,
        is_insert_mode = true,
      })

      utils.keyplug('lttb-spectre', spectre.open, {
        desc = 'spectre.nvim',
      })

      utils.keyplug('lttb-spectre-search-in-file', spectre.open_file_search, {
        desc = 'spectre.nvim | search in file',
      })

      utils.keyplug('lttb-spectre-search-word', function()
        spectre.open_visual({ select_word = true })
      end, {
        desc = 'spectre.nvim | search word',
      })

      utils.keyplug('lttb-spectre-open-visual', function()
        spectre.open_visual({ select_word = true })
      end, {
        desc = 'spectre.nvim | open visual',
      })
    end,
  },

  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      'telescope',
      hls = {
        header_bind = 'DiagnosticWarn',
        header_text = 'DiagnosticInfo',
      },
    },
    keys = function()
      local fzf = require('fzf-lua')
      local actions = require('fzf-lua.actions')
      local path = require('fzf-lua.path')

      return {
        -- {
        --   '<D-f>',
        --   function()
        --     fzf.grep_curbuf({
        --       winopts = {
        --         preview = {
        --           layout = 'vertical',
        --           delay = 5,

        --           vertical = 'up:40%',
        --         },
        --       },
        --     })
        --   end,
        --   desc = 'Fuzzily search in current buffer',
        --   silent = true,
        -- },

        { '<D-r>', fzf.resume, desc = 'fzf: resume' },

        utils.cmd_shift('f', {
          function()
            fzf.grep_project({
              fzf_opts = {
                ['--layout'] = 'reverse',
                ['--info'] = 'inline',
              },

              file_ignore_patterns = {
                'lazy-lock.json',
                '*.lock',
                'package-lock.json',
                'LICENSE',
              },

              winopts = {
                preview = {
                  layout = 'vertical',
                  delay = 5,
                  vertical = 'up:40%',
                },
              },

              prompt = '  ',

              actions = {
                ['ctrl-l'] = {
                  function(selected, opts)
                    local entry = path.entry_to_file(selected[1], opts, opts.force_uri)
                    local fullpath = entry.path or entry.uri and entry.uri:match('^%a+://(.*)')
                    if not path.starts_with_separator(fullpath) then
                      fullpath = path.join({ opts.cwd or opts._cwd or vim.loop.cwd(), fullpath })
                    end

                    require('lttb.dev.toggle_floats').toggle_floats(function()
                      vim.cmd('e ' .. fullpath)

                      vim.schedule(function()
                        if entry.line > 1 or entry.col > 1 then
                          -- make sure we have valid column
                          -- 'nvim-dap' for example sets columns to 0
                          entry.col = entry.col and entry.col > 0 and entry.col or 1
                          vim.api.nvim_win_set_cursor(0, { tonumber(entry.line), tonumber(entry.col) - 1 })
                        end
                      end)
                    end)

                    -- utils.log(selected[1])
                    -- actions.file_edit(selected, opts)
                  end,
                  actions.resume,
                },
                -- ['ctrl-l'] = function(selected, opts)
                --   utils.log(selected)

                --   return false

                --   -- actions.file_open_in_background(selected, opts)
                -- end,
              },
            })
          end,
          desc = 'fzf: search',
        }),
      }
    end,
  },
}
