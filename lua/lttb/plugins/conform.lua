local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    init = function()
      vim.keymap.set({ 'n', 'v' }, '<S-M-f>', function()
        require('conform').format({ async = true })
      end)
    end,
    opts = {
      notify_on_error = false,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function(bufnr)
        if vim.b.ls_biome then
          -- vim.lsp.buf.code_action({
          --   context = {
          --     only = { 'source.fixAll.biome', 'source.organizeImports.biome' },
          --     diagnostics = {},
          --   },
          --   apply = true,
          -- })
        end

        local timeout_ms = 2000
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
          timeout_ms = timeout_ms,
          lsp_format = 'never',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        zsh = { 'shfmt' },
        sh = { 'shfmt' },
        toml = { 'taplo' },

        -- _ = { 'trim_whitespace', lsp_format = 'last' },
      },
    },
  },
}
