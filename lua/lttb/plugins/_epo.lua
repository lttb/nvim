local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

if true then
  return {}
end

return {
  {
    'nvimdev/epo.nvim',
    opts = {
      fuzzy = true,
      debounce = 50,
      signature = false,
    },
  },
}
