local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local js = { { 'prettierd', 'prettier' }, 'eslint_d' }

return {
  'stevearc/conform.nvim',
  enabled = true,
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = js,
      typescript = js,
      typescriptreact = js,
      json = js,
      markdown = js,

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
