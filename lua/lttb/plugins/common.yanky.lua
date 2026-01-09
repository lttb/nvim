return {
  {
    enabled = false,
    'gbprod/yanky.nvim',
    vscode = true,
    event = 'VeryLazy',
    config = function()
      -- vim.keymap.set('v', 'y', function()
      --   return 'my"' .. vim.v.register .. 'y`y'
      -- end, { expr = true })

      -- vim.opt.clipboard = 'unnamedplus'

      require('yanky').setup({
        highlight = {
          on_yank = true,
          timer = 200,
        },
      })

      vim.api.nvim_set_hl(0, 'YankyYanked', { link = 'CursorLine' })
      vim.api.nvim_set_hl(0, 'YankyPut', { link = 'CursorLine' })
    end,
    keys = {
      -- { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
      -- { 'p',  '<Plug>(YankyPutAfter)',   mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
      -- { 'P',  '<Plug>(YankyPutBefore)',  mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
      -- { 'gp', '<Plug>(YankyGPutAfter)',  mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
      -- { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
    },
  },
}
