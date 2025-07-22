local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'A7Lavinraj/fyler.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    branch = 'stable',
    opts = {
      auto_confirm_simple_edits = true,
      close_on_select = false,
      views = {
        explorer = {
          width = 0.25,
          height = 1,
          kind = 'split:left',
        },
      },
    },
  },
}
