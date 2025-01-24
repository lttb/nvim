-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'echasnovski/mini.icons',
    event = 'VeryLazy',
    version = '*',
    opts = {},
    config = function()
      local MiniIcons = require('mini.icons')
      MiniIcons.setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },

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
          winblend = 5,
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

      return {
        {
          '<D-j>',
          function()
            term:toggle()
          end,
          desc = 'Toggle Terminal',
          mode = { 'n', 't', 'i' },
        },
        utils.cmd_shift('g', {
          function()
            broot.cmd = 'broot'
            broot:toggle()
          end,
        }),
        {
          '<D-g>',
          function()
            lazygit.cmd = 'DELTA_FEATURES="+' .. vim.o.background .. '" lazygit'
            lazygit:toggle()
          end,
          desc = 'Toggle lazy Git',
          mode = { 'n', 't', 'i' },
        },
      }
    end,
  },

  {
    -- used for lazygit
    'willothy/flatten.nvim',
    config = true,
    -- or pass configuration with
    -- opts = {  }
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
    opts = {
      window = {
        open = 'alternate',
      },
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    -- -- @see https://github.com/folke/noice.nvim/issues/921#issuecomment-2253363579
    -- commit = 'd9328ef903168b6f52385a751eb384ae7e906c6f',
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
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,            -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },

      messages = {
        view_error = 'mini',
        view_warn = 'mini',
        view = 'mini',
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
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    version = '*',
    opts = function()
      return {
        options = {
          themable = true,

          -- for some reason, a regular cross isn't rendered in kitty correctly (it's much larger)
          buffer_close_icon = '󰅖',

          offsets = {
            {
              filetype = 'oil',
              text = 'File Explorer',
              highlight = 'Directory',
              separator = false, -- use a "true" to enable the default, or set your own character
            },
            {
              filetype = 'no-neck-pain',
              text = '',
              highlight = 'Directory',
              separator = false, -- use a "true" to enable the default, or set your own character
            },
          },

          separator_style = 'thin',

          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },

          diagnostics = 'nvim_lsp',
        },
      }
    end,
  },

  {
    'mvllow/modes.nvim',
    event = 'VeryLazy',
    opts = {
      line_opacity = 0.15,

      colors = {
        visual = '#a89984',
      },
    },
  },

  {
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
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      utils.cmd_shift('m', { '<cmd>Trouble diagnostics toggle<cr>', desc = 'Trouble: Diagnostics Toggle' }),
    },
  },

  {
    'shortcuts/no-neck-pain.nvim',
    event = 'VeryLazy',
    opts = {
      buffers = {
        right = {
          enabled = false,
        },
      },
      autocmds = {
        enableOnVimEnter = false,
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
    'lttb/flash-select.nvim',
    event = 'LazyFile',
    opts = {},
  },
}
