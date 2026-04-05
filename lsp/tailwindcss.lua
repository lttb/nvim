local root_markers = {
  'tailwind.config.js',
  'tailwind.config.cjs',
  'tailwind.config.mjs',
  'tailwind.config.ts',
  'tailwind.config.cts',
  'tailwind.config.mts',
}

return {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
  },
  root_markers = root_markers,
  -- Explicit root_dir to prevent nvim-lspconfig's heavier version from running
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, root_markers)
    if root then
      on_dir(root)
    end
  end,
  workspace_required = true,
}
