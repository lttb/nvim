-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    -- { 'tpope/vim-sleuth' },

    {
      'nvim-tree/nvim-web-devicons',
    },

    { 'JoosepAlviste/nvim-ts-context-commentstring' },
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup({
          ignore = '^$',
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        })
      end,
    },

    {
      'declancm/cinnamon.nvim',
      config = function()
        require('cinnamon').setup({
          default_keymaps = true,
          extra_keymaps = true,
          extended_keymaps = true,

          hide_cursor = true,
          max_length = 50,
          scroll_limit = 150,
          always_scroll = true,
        })
      end,
      -- enabled = not utils.is_neovide(),
      enabled = false,
    },

    {
      'numToStr/FTerm.nvim',
      config = function()
        require('FTerm').setup({
          auto_close = true,
          border = { { ' ', 'WinSeparator' } },
          blend = 10,
          hl = 'NeoTreeNormal',
        })

        utils.keyplug('lttb-toggle-term', function()
          require('FTerm').toggle()
        end)
      end,
      enabled = false,
    },

    {
      'akinsho/toggleterm.nvim',
      config = function()
        require('toggleterm').setup()

        local Terminal = require('toggleterm.terminal').Terminal
        local term = Terminal:new({
          hidden = true,
          dir = 'git_dir',
          direction = 'float',
          float_opts = {
            border = { { ' ', 'WinSeparator' } },
            winblend = 5,
          },
        })

        utils.keyplug('lttb-toggle-term', function()
          term:toggle()
        end)
      end,
    },

    {
      'folke/noice.nvim',
      opts = {
        presets = {
          command_palette = true, -- position the cmdline and popupmenu together
        },
      },
      dependencies = {
        'MunifTanjim/nui.nvim',
      },
      -- enabled = not utils.is_goneovim(),
      enabled = false,
    },

    {
      'luukvbaal/statuscol.nvim',
      config = function()
        require('statuscol').setup({
          separator = ' ',
        })
      end,
      enabled = false,
      -- enabled = vim.fn.has('nvim-0.9.0') == 1,
    },

    {
      'gaoDean/autolist.nvim',
      ft = {
        'markdown',
        'text',
        'tex',
        'plaintex',
      },
      config = function()
        local autolist = require('autolist')
        autolist.setup()
        autolist.create_mapping_hook('i', '<CR>', autolist.new)
        autolist.create_mapping_hook('i', '<Tab>', autolist.indent)
        autolist.create_mapping_hook('i', '<S-Tab>', autolist.indent, '<C-D>')
        autolist.create_mapping_hook('n', 'o', autolist.new)
        autolist.create_mapping_hook('n', 'O', autolist.new_before)
        autolist.create_mapping_hook('n', '>>', autolist.indent)
        autolist.create_mapping_hook('n', '<<', autolist.indent)
        autolist.create_mapping_hook('n', '<C-r>', autolist.force_recalculate)
        autolist.create_mapping_hook('n', '<leader>x', autolist.invert_entry, '')
        vim.api.nvim_create_autocmd('TextChanged', {
          pattern = '*',
          callback = function()
            vim.cmd.normal({
              autolist.force_recalculate(nil, nil),
              bang = false,
            })
          end,
        })
      end,
      -- feels quite buggy, disable for now
      enabled = false,
    },
  },
}
