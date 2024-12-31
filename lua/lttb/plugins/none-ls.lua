local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvimtools/none-ls.nvim',
    event = 'LazyFile',
    dependencies = { 'davidmh/cspell.nvim', 'nvimtools/none-ls-extras.nvim' },
    opts = function()
      local null_ls = require('null-ls')
      local cspell = require('cspell')

      return {
        sources = {
          cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity['INFO']
            end,
          }),
          cspell.code_actions,

          -- require('none-ls.code_actions.eslint'),
          -- require('none-ls.diagnostics.eslint'),
          -- require('none-ls.formatting.eslint'),

          -- null_ls.builtins.formatting.prettier,
        },
      }
    end,
  },
}
