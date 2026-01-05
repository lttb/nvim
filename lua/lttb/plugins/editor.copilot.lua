return {
  {
    'zbirenbaum/copilot.lua',
    enabled = vim.env.HOST_CODENAME == 'canary',
    dependencies = { 'copilotlsp-nvim/copilot-lsp' },
    cmd = 'Copilot',
    opts = {},
  },
}
