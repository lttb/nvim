local M = {}

M.setup = function(settings)
  local utils = require('lttb.utils')

  require('nvim-treesitter.configs').setup(vim.tbl_deep_extend('force', {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'lua', 'typescript', 'rust', 'go', 'python' },

    highlight = {
      enable = not utils.is_vscode(),
    },

    indent = {
      enable = true,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },

    textsubjects = {
      enable = true,
      prev_selection = ',', -- (Optional) keymap to select the previous selection
      keymaps = {
        ['.'] = 'textsubjects-smart',
        [';'] = 'textsubjects-container-outer',
        ['i;'] = 'textsubjects-container-inner',
      },
    },

    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          -- ['af'] = '@function.outer',
          -- ['if'] = '@function.inner',
          -- ['as'] = '@statement.outer',
          -- ['is'] = '@statement.inner',
          -- ['ac'] = '@class.outer',
          -- ['ic'] = '@class.inner',
        },
      },

      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },

      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = {
            query = '@class.outer',
            desc = 'Next class start',
          },
          [']p'] = '@parameter.inner',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
          [']P'] = '@parameter.inner',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
          ['[p'] = '@parameter.inner',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
          ['[P'] = '@parameter.inner',
        },
      },

      lsp_interop = {
        enable = true,
        border = 'none',
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
          ['<leader>dF'] = '@class.outer',
        },
      },
    },
  }, settings))
end

require('lttb.plugins.treesitter-hl')

return M
