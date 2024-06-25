local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    enabled = false,
    'tpope/vim-fugitive',
    event = 'VimEnter',
  },

  {
    enabled = false,
    'tpope/vim-rhubarb',
    event = 'VimEnter',
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'VimEnter',
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 250,
        -- show line blame after diagnostics
        virt_text_priority = 5000,
      },
      current_line_blame_formatter = '    <author>, <author_time:%R> • <summary>',
      current_line_blame_formatter_nc = '    You, <author_time:%R>',

      -- TODO: think about keymaps
    },
  },
}
