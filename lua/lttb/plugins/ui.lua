-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

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
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    version = '*',
    opts = function()
      local bufferline = require('bufferline')

      return {
        options = {
          themable = true,

          style_preset = {
            bufferline.style_preset.no_italic,
            bufferline.style_preset.minimal,
          },

          color_icons = false,

          always_show_bufferline = false,
          auto_toggle_bufferline = true,

          offsets = {
            {
              filetype = 'oil',
              text = 'File Explorer',
              highlight = 'Directory',
              separator = false, -- use a "true" to enable the default, or set your own character
            },
            {
              filetype = 'neo-tree',
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

            {
              filetype = 'snacks_picker_list',
              text = '',
              highlight = 'Directory',
              separator = false, -- use a "true" to enable the default, or set your own character
            },
          },

          show_buffer_icons = false,
          show_buffer_close_icons = false,

          separator_style = { '', '' },

          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },

          diagnostics = false,
        },

        highlights = {
          fill = {
            bg = { highlight = 'WinSeparator', attribute = 'bg' },
          },

          background = {
            bg = { highlight = 'WinSeparator', attribute = 'bg' },
          },

          info = {
            bg = { highlight = 'WinSeparator', attribute = 'bg' },
          },

          duplicate = {
            bg = { highlight = 'WinSeparator', attribute = 'bg' },
          },

          modified = {
            bg = { highlight = 'WinSeparator', attribute = 'bg' },
          },
          modified_visible = {
            bg = { highlight = 'Normal', attribute = 'bg' },
          },
          modified_selected = {
            bg = { highlight = 'Normal', attribute = 'bg' },
          },
        },
      }
    end,
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

  {
    'saghen/blink.indent',
    version = 'v1.0.0',
    --- @module 'blink.indent'
    --- @type blink.indent.Config
    opts = {
      static = {
        char = utils.is_neovide() and '┊' or '┊',
        highlights = { 'IblIndent' },
      },
      scope = {
        char = utils.is_neovide() and '┊' or '┊',
        highlights = { 'IblScope' },
      },
    },
  },
}
