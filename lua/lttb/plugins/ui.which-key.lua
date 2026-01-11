return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    cmd = 'WhichKey',
    opts = {},
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },
}
