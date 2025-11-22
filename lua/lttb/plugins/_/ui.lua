-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {


  {
    enabled = false,
    'folke/noice.nvim',
    event = 'VeryLazy',
    -- -- @see https://github.com/folke/noice.nvim/issues/921#issuecomment-2253363579
    -- commit = 'd9328ef903168b6f52385a751eb384ae7e906c6f',
    --- @type NoiceConfig
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },

        progress = {
          enabled = false,
        },

        signature = {
          enabled = false,
        },

        hover = { silent = true },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },

      -- @see https://github.com/LazyVim/LazyVim/discussions/830
      routes = {
        filter = {
          event = 'notify',
          find = 'No information available',
        },
        opts = { skip = true },
      },

      notify = {
        enabled = false,
      },

      views = {
        hover = {
          border = {
            style = {
              { '╭', 'LspFloatBorder' },
              { '╌', 'LspFloatBorder' },
              { '╮', 'LspFloatBorder' },
              { '╎', 'LspFloatBorder' },
              { '╯', 'LspFloatBorder' },
              { '╌', 'LspFloatBorder' },
              { '╰', 'LspFloatBorder' },
              { '╎', 'LspFloatBorder' },
            },
            padding = { 0, 1 },
          },
        },
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  {
    enabled = false,
    'romgrk/barbar.nvim',
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      auto_hide = 1,

      sidebar_filetypes = {
        oil = true,
      },
    },
  },


  {
    enabled = false,
    'mvllow/modes.nvim',
    event = 'VeryLazy',
    opts = {
      line_opacity = 0.15,

      set_cursorline = false,

      colors = {
        visual = '#a89984',
      },
    },
  },

  {
    enabled = false,
    'folke/which-key.nvim',
    event = 'VeryLazy',
    cmd = 'WhichKey',
    opts = {},
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },

  {
    enabled = false, -- slow? see https://github.com/folke/todo-comments.nvim/issues/358
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,

      highlight = {
        keyword = 'fg',
      },
    },
  },

  {
    enabled = false,
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      utils.cmd_shift('m', { '<cmd>Trouble diagnostics toggle<cr>', desc = 'Trouble: Diagnostics Toggle' }),
    },
  },

  {
    enabled = false,
    'shortcuts/no-neck-pain.nvim',
    event = 'VeryLazy',
    opts = {
      width = 'textwidth',

      buffers = {
        right = {
          -- enabled = false,
        },
      },
      autocmds = {
        enableOnVimEnter = false,
      },
      integrations = {
        NvimTree = {
          position = 'left',
          reopen = false,
        },
      },
    },
  },

  {
    enabled = false,
    'Chaitanyabsprip/fastaction.nvim',
    event = 'LazyFile',
    ---@type FastActionConfig
    opts = {
      register_ui_select = true,
    },
    keys = {
      { '<C-.>', '<cmd>lua require("fastaction").code_action()<CR>', desc = 'Code Action' },
    },
  },

  {
    enabled = false,
    'lttb/flash-select.nvim',
    event = 'LazyFile',
    opts = {},
  },

}
