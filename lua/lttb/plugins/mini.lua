local utils = require('lttb.utils')

return {
  {
    'echasnovski/mini.surround',
    version = '*',
    config = function()
      require('mini.surround').setup({
        mappings = {
          add = '<C-s>a',            -- Add surrounding in Normal and Visual modes
          delete = '<C-s>d',         -- Delete surrounding
          find = '<C-s>f',           -- Find surrounding (to the right)
          find_left = '<C-s>F',      -- Find surrounding (to the left)
          highlight = '<C-s>h',      -- Highlight surrounding
          replace = '<C-s>r',        -- Replace surrounding
          update_n_lines = '<C-s>n', -- Update `n_lines`

          suffix_last = 'l',         -- Suffix to search with "prev" method
          suffix_next = 'n',         -- Suffix to search with "next" method
        },
      })
    end,
  },
  {
    'echasnovski/mini.ai',
    version = '*',
    opts = {
      search_method = 'cover_or_nearest',
    },
  },
  { 'echasnovski/mini.align', version = '*', opts = {} },

  {
    cond = not utils.is_vscode(),
    'echasnovski/mini.bufremove',
    version = '*',
    opts = {},
  },
  {
    cond = not utils.is_vscode(),
    'echasnovski/mini.cursorword',
    version = '*',
    opts = {},
  },
}
