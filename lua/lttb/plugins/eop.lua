local utils = require('lttb.utils')

if utils.is_vscode() then
  return
end

return {
  {
    'nvimdev/epo.nvim',
    enabled = false,
    opts = {
      fuzzy = true,
      debounce = 50,
      signature = false,
    },
  },
}
