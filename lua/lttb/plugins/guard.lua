local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  local ft = require('guard.filetype')

  ft('lua'):fmt('lsp'):append('stylua')

  ft('typescript,javascript,typescriptreact'):fmt('prettier'):lint('eslint')

  require('guard').setup({
    fmt_on_save = true,
    lsp_as_default_formatter = true,
  })
end

return {
  'nvimdev/guard.nvim',
  config = config,
  dependencies = {
    {
      -- TODO: switch to 'nvim/guard-collection' after https://github.com/nvimdev/guard-collection/pull/7
      'sirreal/guard-collection',
      branch = 'add-eslint-linter'
    },
  },
}
