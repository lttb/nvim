local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

if true then
  return {}
end

return {
  {
    enabled = false,
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
}
