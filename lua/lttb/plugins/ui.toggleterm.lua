local utils = require('lttb.utils')

return {
  {
    'akinsho/toggleterm.nvim',
    -- sync load is critical to work properly with editing in lazygit
    config = true,
    keys = function()
      local Terminal = require('toggleterm.terminal').Terminal
      local term_options = {
        hidden = true,
        dir = 'git_dir',
        direction = 'float',
        highlights = {
          NormalFloat = {
            link = 'Normal',
          },
          FloatBorder = {
            link = 'FloatBorder',
          },
        },
        float_opts = {
          border = 'curved',
          -- winblend = 5,
        },
        winbar = {
          enabled = false,
          name_formatter = function(term) --  term: Terminal
            return term.name
          end,
        },
      }
      local term = Terminal:new(term_options)

      -- new term_options object is needed to avoid caching
      local lazygit = Terminal:new(vim.tbl_extend('keep', {}, term_options))

      -- new term_options object is needed to avoid caching
      local broot = Terminal:new(vim.tbl_extend('keep', {}, term_options))

      -- new term_options object is needed to avoid caching
      local local_term = Terminal:new(vim.tbl_extend('keep', {}, term_options))

      return {
        {
          '<D-j>',
          function()
            __term__ = term:toggle()
          end,
          desc = 'Toggle Terminal',
          mode = { 'n', 't', 'i' },
        },
        utils.cmd_shift('j', {
          function()
            local_term.dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
            __term__ = local_term:toggle()
          end,
          mode = { 'n', 't', 'i' },
        }),
        utils.cmd_shift('g', {
          function()
            broot.cmd = 'broot'
            __term__ = broot:toggle()
          end,
          mode = { 'n', 't', 'i' },
        }),
        {
          '<D-g>',
          function()
            lazygit.cmd = 'lazygit'
            __term__ = lazygit:toggle()
          end,
          desc = 'Toggle lazy Git',
          mode = { 'n', 't', 'i' },
        },
      }
    end,
  },
}
