local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    -- NOTE: build failed,
    -- Import 'https://deno.land/x/emit@0.38.1/mod.ts' failed: error sending request for url
    -- (https://deno.land/x/emit@0.38.1/mod.ts): client error (Connect): invalid peer certificate: UnknownIssuer
    enabled = false,
    'toppair/peek.nvim',
    event = { 'VeryLazy' },
    build = 'deno task --quiet build:fast',
    config = function()
      require('peek').setup()
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
  },
  {
    enabled = false,
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && bun install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
}
