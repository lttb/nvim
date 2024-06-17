local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'davidmh/cspell.nvim' },
    opts = function()
      local cspell = require('cspell')

      return {
        sources = {
          cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity['INFO']
            end,
          }),
          cspell.code_actions,
        },
      }
    end,
  },
}
