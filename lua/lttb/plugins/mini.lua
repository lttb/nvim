local utils = require('lttb.utils')

return {
  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
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
    event = 'VeryLazy',
    version = '*',
    opts = {
      search_method = 'cover_or_nearest',
    },
  },
  {
    'echasnovski/mini.align',
    event = 'VeryLazy',
    version = '*',
    opts = {},
  },

  {
    cond = not utils.is_vscode(),
    event = 'VeryLazy',
    'echasnovski/mini.bufremove',
    version = '*',
    opts = {},
  },
  {
    cond = not utils.is_vscode(),
    event = 'VeryLazy',
    'echasnovski/mini.cursorword',
    version = '*',
    opts = {},
  },

  {
    cond = not utils.is_vscode(),
    event = 'VeryLazy',
    'echasnovski/mini.files',
    version = '*',
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set('n', '-', MiniFiles.go_out, { buffer = buf_id })
          vim.keymap.set('n', '_', function()
            MiniFiles.open(vim.fn.getcwd(), false)
          end, { buffer = buf_id })

          vim.keymap.set('n', '<C-f>', function()
            local entry = MiniFiles.get_fs_entry(buf_id)
            if not entry then
              return
            end

            MiniFiles.close()
            require('lttb.utils.fs').find_in_dir(entry.fs_type, entry.path)
          end, { buffer = buf_id })

          vim.keymap.set('n', '<C-y>', function()
            local entry = MiniFiles.get_fs_entry(buf_id)
            if not entry then
              return
            end

            require('lttb.utils.fs').copy_selector(entry.path)
          end, { buffer = buf_id })
        end,
      })
    end,
    keys = {
      {
        '<D-e>',
        function()
          if not MiniFiles.close() then
            MiniFiles.open(vim.api.nvim_buf_get_name(0))
          end
        end,
      },
      {
        '<S-D-e>',
        function()
          MiniFiles.open()
        end,
      },
    },
    opts = {
      mappings = {
        go_in = 'L',
        go_in_plus = '<CR>',
        go_out = '-',
        synchronize = '<D-s>',
      },
    },
  },
}
