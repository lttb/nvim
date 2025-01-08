local root_file = {
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.yml',
  '.prettierrc.yaml',
  '.prettierrc.json5',
  '.prettierrc.js',
  'prettier.config.js',
  '.prettierrc.mjs',
  'prettier.config.mjs',
  '.prettierrc.cjs',
  'prettier.config.cjs',
  '.prettierrc.toml',
}

return {
  default_config = {
    cmd = { 'pretterls' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'vue',
      'css',
      'scss',
      'less',
      'html',
      'json',
      'jsonc',
      'yaml',
      'markdown',
      'markdown.mdx',
      'graphql',
      'handlebars',
    },
    root_dir = function(fname)
      local util = require('lspconfig.util')

      root_file = util.insert_package_json(root_file, 'prettier', fname)
      return util.root_pattern(unpack(root_file))(fname)
    end,
  },
}
