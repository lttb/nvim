local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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

        utils.cmd_shift('r', {
          fzf.resume,
          desc = 'fzf: resume',
        }),

        utils.cmd_shift('f', {
          function()
            local tf = require('lttb.dev.toggle_floats')

            if tf.is_hidden('fzf') then
              tf.toggle_floats('fzf')

              return
            end

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
                ['enter'] = {
                  function(selected, opts)
                    tf.toggle_floats('fzf', function()
                      actions.file_edit(selected, opts)
                    end)
                  end,
                  actions.resume,
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
