return {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,

  settings = {
    typescript = {
      preferences = {
        importModuleSpecifier = 'non-relative',
        importModuleSpecifierEnding = 'auto',

        -- optional but commonly nice:
        includePackageJsonAutoImports = 'auto',
      },
    },
  },
}
