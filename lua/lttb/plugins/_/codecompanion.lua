local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionCmd', 'CodeCompanionActions' },
    event = 'VeryLazy',
    config = function()
      require('lttb.plugins.codecompanion.fidget-spinner'):init()

      require('codecompanion').setup({})
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'j-hui/fidget.nvim',
    },
    keys = {
      { '<D-i>',   ':CodeCompanion ',               desc = '[AI] Inline Assistant', mode = { 'x', 'n' } },
      { '<D-S-i>', '<cmd>CodeCompanionActions<cr>', desc = '[AI] Actions',          mode = { 'x', 'n' } },
      { '<D-C-i>', '<cmd>CodeCompanionChat<cr>',    desc = '[AI] Chat',             mode = { 'x', 'n' } },
    },
  },
}
