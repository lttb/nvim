return {
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionCmd', 'CodeCompanionActions' },
    version = '^18.0.0',
    event = 'VeryLazy',
    config = function()
      require('lttb.plugins.codecompanion.fidget-spinner'):init()

      require('codecompanion').setup({
        adapters = {
          http = {
            claude_code_pro = function()
              return require('lttb.plugins.codecompanion.claude-adapter')
            end,
          },
          acp = {
            claude_code = function()
              return require('codecompanion.adapters').extend('claude_code', {
                env = {
                  CLAUDE_CODE_OAUTH_TOKEN = 'cmd:fnox get CLAUDE_CODE_OAUTH_TOKEN',
                },
              })
            end,
          },
        },
        interactions = {
          chat = {
            adapter = 'claude_code_pro',
          },
          inline = {
            adapter = 'claude_code_pro',
          },
          cmd = {
            adapter = 'claude_code_pro',
          },
        },
      })
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
