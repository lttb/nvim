local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,

    null_ls.builtins.diagnostics.eslint,

    -- null_ls.builtins.diagnostics.cspell.with({
    --   diagnostics_postprocess = function(diagnostic)
    --     diagnostic.severity = vim.diagnostic.severity["WARN"]
    --   end,
    -- }),
    -- null_ls.builtins.completion.spell,
  },
})
