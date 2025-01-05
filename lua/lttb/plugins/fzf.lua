local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    opts = {
      lsp = {
        -- @see https://github.com/nvimtools/none-ls.nvim/wiki/Compatibility-with-other-plugins
        -- make lsp requests synchronous so they work with null-ls
        async_or_timeout = 3000,
      },
      hls = {
        header_bind = 'DiagnosticWarn',
        header_text = 'DiagnosticInfo',
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
        return res
      end

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

        {
          '<D-p>',
          function()
            require('fzf-lua').files()
          end,
          desc = 'Search Files',
        },

        -- utils.cmd_shift('r', {
        --   function()
        --     get().fzf.resume()
        --   end,
        --   desc = 'fzf: resume',
        -- }),

        utils.cmd_shift('f', {
          function()
            local is_unhidden = get().fzf.win.unhide()

            if is_unhidden then
              return
            end

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
