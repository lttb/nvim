return {
  { "projekt0n/github-nvim-theme", lazy = true },
  { "rktjmp/lush.nvim", lazy = true },
  {
    "mcchrish/zenbones.nvim",
    lazy = true,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.g.zenbones_lightness = "bright"
    end,
  },
}
