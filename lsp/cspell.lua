return {
  cmd = { 'cspell-lsp-wrapper', '--stdio' },
  root_dir = vim.fn.getcwd(),
  init_options = {
    home = vim.fn.expand('~'),
  },

  single_file_support = true,

  handlers = {
    ['textDocument/publishDiagnostics'] = function(err, result, ctx, conf)
      vim.tbl_map(function(d)
        d.severity = vim.diagnostic.severity.INFO
      end, result.diagnostics or {})
      vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, conf)
    end,
  },
}
