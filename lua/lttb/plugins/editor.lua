local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'nmac427/guess-indent.nvim',
    event = 'LazyFile',
  },

  {
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
    event = 'LazyFile',
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
    'axelvc/template-string.nvim',
    event = 'LazyFile',
    config = true,
  },

  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
  },

  -- NOTE: consider alternative https://github.com/chrisgrieser/nvim-early-retirement
  {
    'axkirillov/hbac.nvim',
    event = 'VeryLazy',
  },

  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.97,
      },
    },
  },

  -- better quick fix window
  { 'kevinhwang91/nvim-bqf', event = 'LazyFile' },
}
