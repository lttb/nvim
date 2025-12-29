local utils = require('lttb.utils')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    event = { 'LazyFile', 'VeryLazy' },
    lazy = false,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    config = function()
      require('nvim-treesitter').setup({
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'lua', 'typescript', 'rust', 'go', 'python' },

        auto_install = true,

        -- refactor = {
        --   highlight_definitions = {
        --     enable = false,
        --     -- Set to false if you have an `updatetime` of ~100.
        --     clear_on_cursor_move = true,
        --   },
        --
        --   highlight_current_scope = { enable = false },
        -- },

        highlight = {
          enable = not utils.is_vscode(),

          additional_vim_regex_highlighting = false,
        },

        -- indent = {
        --   enable = true,
        -- },

        -- incremental_selection = {
        --   enable = true,
        --   keymaps = {
        --     init_selection = 'gnn',
        --     node_incremental = 'grn',
        --     scope_incremental = 'grc',
        --     node_decremental = 'grm',
        --   },
        -- },

        -- textsubjects = {
        --   enable = true,
        --   prev_selection = ',', -- (Optional) keymap to select the previous selection
        --   keymaps = {
        --     ['.'] = 'textsubjects-smart',
        --     [';'] = 'textsubjects-container-outer',
        --     ['i;'] = 'textsubjects-container-inner',
        --   },
        -- },

        -- textobjects = {
        --   select = {
        --     enable = true,
        --
        --     -- Automatically jump forward to textobj, similar to targets.vim
        --     lookahead = true,
        --
        --     keymaps = {
        --       -- You can use the capture groups defined in textobjects.scm
        --       -- ['af'] = '@function.outer',
        --       -- ['if'] = '@function.inner',
        --       -- ['as'] = '@statement.outer',
        --       -- ['is'] = '@statement.inner',
        --       -- ['ac'] = '@class.outer',
        --       -- ['ic'] = '@class.inner',
        --     },
        --   },
        --
        --   swap = {
        --     enable = true,
        --     swap_next = {
        --       ['<leader>a'] = '@parameter.inner',
        --     },
        --     swap_previous = {
        --       ['<leader>A'] = '@parameter.inner',
        --     },
        --   },
        --
        --   move = {
        --     enable = true,
        --     set_jumps = true, -- whether to set jumps in the jumplist
        --     goto_next_start = {
        --       [']m'] = '@function.outer',
        --       [']]'] = {
        --         query = '@class.outer',
        --         desc = 'Next class start',
        --       },
        --       [']p'] = '@parameter.inner',
        --     },
        --     goto_next_end = {
        --       [']M'] = '@function.outer',
        --       [']['] = '@class.outer',
        --       [']P'] = '@parameter.inner',
        --     },
        --     goto_previous_start = {
        --       ['[m'] = '@function.outer',
        --       ['[['] = '@class.outer',
        --       ['[p'] = '@parameter.inner',
        --     },
        --     goto_previous_end = {
        --       ['[M'] = '@function.outer',
        --       ['[]'] = '@class.outer',
        --       ['[P'] = '@parameter.inner',
        --     },
        --   },
        --
        --   lsp_interop = {
        --     enable = true,
        --     border = 'none',
        --     peek_definition_code = {
        --       ['<leader>df'] = '@function.outer',
        --       ['<leader>dF'] = '@class.outer',
        --     },
        --   },
        -- },
      })

      -- @see https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
      vim.filetype.add({
        extension = {
          mdx = 'mdx',
        },
      })

      vim.treesitter.language.register('markdown', 'mdx')
      vim.treesitter.language.register('tsx', { 'typescript', 'typescriptreact' })
    end,
    dependencies = {
      -- 'nvim-treesitter/nvim-treesitter-refactor',
      -- 'nvim-treesitter/nvim-treesitter-textobjects',
      -- 'RRethy/nvim-treesitter-textsubjects',
      -- {
      --   cond = not utils.is_vscode(),
      --   'nvim-treesitter/playground',
      -- },
      {
        enabled = false,
        cond = not utils.is_vscode(),
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require('treesitter-context').setup({
            separator = '-',
            multiline_threshold = 1,
            max_lines = 5,
            mode = 'topline',
          })
        end,
      },
    },
  },
}
