return {
  { "projekt0n/github-nvim-theme" },
  { "rktjmp/lush.nvim" },
  {
    "mcchrish/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.g.zenbones_lightness = "bright"
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "zengithub_light",
    },
  },
}
