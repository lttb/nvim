local utils = require('lttb.utils')

local function config()
  local null_ls = require('null-ls')

  local lsp_formatting = function(bufnr, async)
    vim.lsp.buf.format({
      -- filter = function(client)
      --   -- use only "null-ls"
      --   return client.name == 'null-ls'
      -- end,
      bufnr = bufnr,
      async = async or false,
    })
  end

  local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.eslint_d,
      null_ls.builtins.formatting.prettier.with({
        extra_filetypes = { 'solidity' },
      }),

      -- null_ls.builtins.diagnostics.eslint,

      -- null_ls.builtins.diagnostics.cspell.with({
      --   diagnostics_postprocess = function(diagnostic)
      --     diagnostic.severity = vim.diagnostic.severity["WARN"]
      --   end,
      -- }),
      -- null_ls.builtins.completion.spell,
    },

    on_attach = function(client, bufnr)
      if not client.supports_method('textDocument/formatting') then
        return
      end

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
        lsp_formatting(bufnr, false)

        -- NOTE: check later, eslint fix all should work automatically
        -- if vim.fn.exists(':EslintFixAll') > 0 then
        --   vim.cmd('EslintFixAll')
        -- end
      end, {
        desc = 'Format current buffer with LSP',
      })

      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })

      local format_timer

      local autocmd_opts = {
        group = augroup,
        buffer = bufnr,
        callback = function()
          if format_timer then
            format_timer:stop()

            if not format_timer:is_closing() then
              format_timer:close()
            end
          end

          format_timer = vim.defer_fn(function()
            lsp_formatting(bufnr, true)
          end, 0)
        end,
      }

      vim.api.nvim_create_autocmd('InsertLeave', autocmd_opts)
      -- vim.api.nvim_create_autocmd('BufWritePre', autocmd_opts)
    end,
  })
end

if utils.is_vscode() then
  return {}
end

return {
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = config,
  },
}
