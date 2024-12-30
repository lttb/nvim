local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
  },
}
