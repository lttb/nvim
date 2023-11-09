local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  -- none-ls
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'mason.nvim' },
    opts = function()
      local null_ls = require('null-ls')

      return {
        sources = {
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.code_actions.cspell,

          -- null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.formatting.eslint_d,
          -- null_ls.builtins.formatting.markdownlint,
          -- null_ls.builtins.formatting.prettierd,

          -- not needed as `typescript-tools` provides it
          -- null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.diagnostics.cspell.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity['INFO']
            end,
          }),
          null_ls.builtins.diagnostics.markdownlint,

          null_ls.builtins.completion.spell,
        },
      }
    end,
  },
}
