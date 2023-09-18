local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local prettier = { { 'prettierd', 'prettier' } }

return {
  'stevearc/conform.nvim',
  enabled = true,
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,

      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace' },
    },

    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
