local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'dmtrKovalenko/fff.nvim',
    branch = 'main',
    -- build = 'cargo build --release',
    opts = {
      -- pass here all the options
    },
    keys = {
      {
        '<leader>ff', -- try it if you didn't it is a banger keybinding for a picker
        function()
          require('fff').find_files()
        end,
        desc = 'Toggle FFF',
      },
    },
  },
}
