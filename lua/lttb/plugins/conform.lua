local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local js_formatter = { 'prettier' }
local js = { 'eslint', js_formatter }

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = js,
      typescript = js,
      typescriptreact = js,
      json = { js_formatter },
      jsonc = { js_formatter },
      markdown = { js_formatter, 'markdownlint' },
      mdx = { js_formatter, 'markdownlint' },
      py = { 'ruff_fix', 'ruff_format' },

      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace' },
    },

    format_after_save = function(bufnr)
      return { lsp_fallback = true }
    end,
  },
}
