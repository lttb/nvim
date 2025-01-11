local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'luckasRanarison/tailwind-tools.nvim',
    event = 'VeryLazy',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    opts = {}, -- your configuration
  },
}
