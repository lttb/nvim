local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    enabled = not utils.is_dotfiles(),
    'dmtrKovalenko/fff.nvim',
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require('fff.download').download_or_build_binary()
    end,
    lazy = false,
    opts = {},
    keys = {
      {
        '<leader><leader>', -- try it if you didn't it is a banger keybinding for a picker
        function()
          if utils.is_dotfiles() then
            require('fzf-lua').git_files({
              cmd = 'git ls-files -c -o --exclude-standard',
            })

            return
          end

          require('fff').find_files()
        end,
        desc = 'Toggle FFF',
      },
    },
  },
}
