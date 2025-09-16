local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    dependencies = { 'elanmed/fzf-lua-frecency.nvim', opts = {} },
    opts = {
      defaults = {
        git_icons = true,
      },
      -- lsp = {
      --   -- @see https://github.com/nvimtools/none-ls.nvim/wiki/Compatibility-with-other-plugins
      --   -- make lsp requests synchronous so they work with null-ls
      --   async_or_timeout = 3000,
      -- },
      -- hls = {
      --   header_bind = 'DiagnosticWarn',
      --   header_text = 'DiagnosticInfo',
      -- },
      --
      fzf_colors = true,
      --
      -- winopts = {
      --   backdrop = 100,
      -- },

      buffers = {
        cwd_only = false,
      },

      frecency = {
        cwd_only = true,
        display_score = false,
      },
    },
    keys = function()
      local res = nil
      local function get()
        if res then
          return res
        end

        res = {}
        res.fzf = require('fzf-lua')
        res.actions = require('fzf-lua.actions')
        res.path = require('fzf-lua.path')
        res.cmd = require('fzf-lua.cmd')
        return res
      end

      return {
        {
          '<leader>ff',
          function()
            -- TODO: raise an issue with `cwd_only` buffers the first item in the list isn't available
            get().fzf.combine({
              pickers = 'buffers,frecency',
            })
          end,
        },

        {
          '<D-f>',
          function()
            get().fzf.grep_curbuf({
              winopts = {
                preview = {
                  layout = 'vertical',
                  delay = 5,

                  vertical = 'up:40%',
                },
              },
            })
          end,
          desc = 'Fuzzily search in current buffer',
          silent = true,
        },

        {
          '<D-p>',
          function()
            get().fzf.git_files({
              cmd = 'git ls-files -c -o --exclude-standard',
            })
          end,
          desc = 'Search Files',
        },

        {
          '<leader>fg',
          function()
            get().fzf.global()
          end,
          desc = 'Search Files',
        },

        {
          '<D-S-p>',
          function()
            get().cmd.run_command()
          end,
          desc = 'Command Palette',
        },

        {
          '<D-o>',
          function()
            get().fzf.buffers()
          end,
          desc = 'Search Buffers',
        },

        -- {
        --   'gl',
        --   function()
        --     get().fzf.lsp_finder()
        --   end,
        --   desc = 'LSP: Finder',
        -- },

        {
          'gd',
          function()
            get().fzf.lsp_definitions()
          end,
          desc = 'LSP: Goto Definition',
        },

        {
          'gD',
          function()
            get().fzf.lsp_typedefs()
          end,
          desc = 'LSP: Type Definition',
        },

        {
          'gi',
          function()
            get().fzf.lsp_implementations()
          end,
          desc = 'LSP: Goto Implementation',
        },

        {
          'gr',
          function()
            get().fzf.lsp_references()
          end,
          desc = 'LSP: Goto References',
        },

        {
          '<leader>sa',
          function()
            get().fzf.files()
          end,
          desc = 'Search All files',
        },

        utils.cmd_shift('r', {
          function()
            get().fzf.resume()
          end,
          desc = 'fzf: resume',
        }),

        utils.cmd_shift('f', {
          function()
            get().fzf.grep_project({
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

              keymap = {
                builtin = {
                  ['<Esc>'] = 'hide',
                },
              },

              actions = {
                ['ctrl-r'] = get().actions.resume,
                ['enter'] = {
                  function(selected, opts)
                    get().fzf.win.hide()

                    vim.schedule(function()
                      get().actions.file_edit(selected, opts)
                    end)
                  end,
                  get().actions.resume,
                },
              },
            })
          end,
          desc = 'fzf: search',
        }),
      }
    end,
  },
}
