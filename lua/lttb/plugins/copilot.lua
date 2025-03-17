local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  { 'zbirenbaum/copilot.lua', cmd = 'Copilot', event = 'VeryLazy', config = true },
}
