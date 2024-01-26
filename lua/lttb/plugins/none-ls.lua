local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'mason.nvim' },
    opts = function()
      local null_ls = require('null-ls')
      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

      return {
        -- @see https://github.com/nvimtools/none-ls.nvim/wiki/Formatting-on-save
        on_attach = function(client, bufnr)
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  timeout_ms = 2000,
                  filter = function(client)
                    return client.name == 'null-ls'
                  end,
                })
              end,
            })
          end
        end,

        sources = {
          null_ls.builtins.code_actions.eslint,
          null_ls.builtins.code_actions.cspell,

          null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.formatting.eslint,
          null_ls.builtins.formatting.markdownlint,
          null_ls.builtins.formatting.prettier,

          -- not needed as `typescript-tools` provides it
          -- null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.diagnostics.cspell.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity['INFO']
            end,
          }),
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.ruff,

          null_ls.builtins.completion.spell,
        },
      }
    end,
  },
}
