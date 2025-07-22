local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nmac427/guess-indent.nvim',
    event = 'LazyFile',
    opts = {},
  },

  {
    enabled = false, -- not maintained
    'vidocqh/auto-indent.nvim',
    event = 'LazyFile',
    opts = {
      lightmode = false,
      ---@param lnum: number
      ---@return number
      indentexpr = function(lnum)
        return require('nvim-treesitter.indent').get_indent(lnum)
      end,
    },
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'LazyFile',
    config = true,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')

      npairs.setup({
        check_ts = true,
        break_undo = true,
        map_c_h = true,
        map_c_w = true,

        -- support coq
        -- map_bs = false,
        -- map_cr = false,
      })

      -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      -- local cmp = require('cmp')
      -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      --
      -- npairs.add_rules({
      --   Rule('**', '**', { 'markdown', 'mdx' }),
      --   Rule('```', '```', { 'mdx' }),
      --   Rule('```.*$', '```', { 'mdx' }):only_cr():use_regex(true),
      -- })
    end,
  },

  {
    enabled = false,
    'saghen/blink.pairs',
    event = 'InsertEnter',
    version = '*',
    dependencies = 'saghen/blink.download',
    opts = {
      highlights = {
        enabled = false,
      },
    },
  },

  {
    'axelvc/template-string.nvim',
    event = 'LazyFile',
    opts = {},
  },

  {
    'folke/ts-comments.nvim',
    event = 'LazyFile',
    opts = {},
  },

  -- NOTE: consider alternative https://github.com/chrisgrieser/nvim-early-retirement
  {
    enabled = false,
    'axkirillov/hbac.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    enabled = false,
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.97,
      },
    },
  },

  -- better quick fix window
  { 'kevinhwang91/nvim-bqf', event = 'LazyFile', opts = {} },

  { 'lttb/macos-text.nvim',  event = 'LazyFile', opts = {} },

  {
    'kwkarlwang/bufjump.nvim',
    event = 'VeryLazy',
    opts = {
      on_success = nil,
    },
    keys = {
      { '<C-P>', ":lua require('bufjump').backward()<cr>",          mode = { 'n' }, silent = true },
      { '<C-N>', ":lua require('bufjump').forward()<cr>",           mode = { 'n' }, silent = true },
      { '<M-o>', ":lua require('bufjump').backward_same_buf()<cr>", mode = { 'n' }, silent = true },
      { '<M-i>', ":lua require('bufjump').forward_same_buf()<cr>",  mode = { 'n' }, silent = true },
    },
  },

  {
    '3rd/image.nvim',
    cond = utils.is_kitty(),
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = 'magick_cli',
    },
  },
}
