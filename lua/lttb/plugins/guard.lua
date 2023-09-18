local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  local ft = require('guard.filetype')

  ft('lua'):fmt('lsp'):append('stylua')

  ft('typescript,javascript,typescriptreact'):fmt('prettier')
  ft('json'):fmt('prettier')

  require('guard').setup({
    fmt_on_save = true,
    lsp_as_default_formatter = true,
  })
end

return {
  'nvimdev/guard.nvim',
  enabled = false,
  config = config,
  dependencies = {
    'nvimdev/guard-collection',
  },
}
