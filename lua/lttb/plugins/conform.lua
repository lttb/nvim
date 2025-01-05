local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function(bufnr)
        local timeout_ms = 500
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }

        if disable_filetypes[vim.bo[bufnr].filetype] then
          return {
            timeout_ms = timeout_ms,
            lsp_format = 'never',
          }
        end

        return {
          timeout_ms = 500,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua', lsp_format = 'last' },
        zsh = { 'shfmt' },
      },
    },
  },
}
