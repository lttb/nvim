local util = require('lspconfig.util')

local root_file = {
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.js',
  'prettier.config.js',
}

return {
  default_config = {
    cmd = { 'prettier_ls' },
    filetypes = { 'typescript', 'typescriptreact' },
    root_dir = function(fname)
      root_file = util.insert_package_json(root_file, 'eslintConfig', fname)
      return util.root_pattern(unpack(root_file))(fname)
    end,
  },
}
