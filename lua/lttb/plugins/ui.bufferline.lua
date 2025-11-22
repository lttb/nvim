return {
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

            {
              filetype = 'fyler',
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
}
