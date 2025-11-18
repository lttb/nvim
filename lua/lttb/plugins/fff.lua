local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'dmtrKovalenko/fff.nvim',
    branch = 'main',
    build = 'cargo build --release',
    opts = {
      -- pass here all the options
    },
    keys = {
      -- {
      --   '<leader><leader>', -- try it if you didn't it is a banger keybinding for a picker
      --   function()
      --     if utils.is_dotfiles() then
      --       require('fzf-lua').git_files({
      --         cmd = 'git ls-files -c -o --exclude-standard',
      --       })
      --
      --       return
      --     end
      --
      --     require('fff').find_files()
      --   end,
      --   desc = 'Toggle FFF',
      -- },
    },
  },
}
