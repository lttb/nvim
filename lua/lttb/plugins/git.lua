local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'tpope/vim-fugitive',
    enabled = false,
    event = 'VimEnter',
  },

  {
    'tpope/vim-rhubarb',
    enabled = false,
    event = 'VimEnter',
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'VimEnter',
    opts = {
      yadm = {
        enable = not utils.is_neovide(), -- for some reason, it doesn't work in neovide
      },

      current_line_blame = true,
      current_line_blame_opts = {
        delay = 250,
        -- show line blame after diagnostics
        virt_text_priority = 5000,
      },
      current_line_blame_formatter = '    <author>, <author_time:%R> • <summary>',
      current_line_blame_formatter_nc = '    You, <author_time:%R>',

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function()
          gs.blame_line({ full = true })
        end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function()
          gs.diffthis('~')
        end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    },
  },
}
