local utils = require("lttb.utils")

if utils.is_vscode() then
  return {}
end

return {
  { "projekt0n/github-nvim-theme" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_light",
    },
  },
}
