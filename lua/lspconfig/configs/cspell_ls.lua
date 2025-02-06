return {
  default_config = {
    cmd = { 'cspell-lsp-wrapper', '--stdio' },
    root_dir = vim.fn.getcwd(),
    init_options = {
      home = vim.fn.expand('~'),
    },

    single_file_support = true,
  },
}
