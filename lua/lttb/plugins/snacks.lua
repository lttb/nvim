local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      dashboard = { enabled = false },
      scratch = { enabled = true },
      indent = {
        enabled = false,

        animate = {
          enabled = false,
        },

        indent = {
          char = utils.is_neovide() and '┊' or '┊',
        },

        scope = {
          char = utils.is_neovide() and '┊' or '┊',
        },
      },
      -- input = { enabled = true },
      -- notifier = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 50 },
          easing = 'linear',
        },
      },
      scope = { enabled = true },

      picker = {
        layout = 'vertical',
        formatters = {
          file = {
            filename_first = true,
            truncate = 200,
          },
        },

        win = {
          -- input window
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            },
          },
        },
      },
      -- words = {},

      notifier = {
        enabled = true,

        style = 'minimal',
        top_down = false,
      },
    },
    config = function(_, opts)
      -- @see https://github.com/LazyVim/LazyVim/blob/d0c366e4d861b848bdc710696d5311dca2c6d540/lua/lazyvim/plugins/init.lua#L21-L29
      local notify = vim.notify
      require('snacks').setup(opts)
      -- -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- -- this is needed to have early notifications show up in noice history
      vim.notify = notify
    end,
    keys = function()
      return {
        -- {
        --   '<leader><leader>',
        --   function()
        --     Snacks.picker.smart({
        --       multi = { 'buffers', 'recent', 'git_files', not utils.is_dotfiles() and 'files' or nil },
        --       filter = { cwd = true },
        --       untracked = true,
        --     })
        --   end,
        --   desc = 'Smart Open',
        -- },

        --{{{ LSP
        {
          'gd',
          function()
            Snacks.picker.lsp_definitions()
          end,
          desc = 'LSP: Goto Definition',
        },

        {
          'gD',
          function()
            Snacks.picker.lsp_type_definitions()
          end,
          desc = 'LSP: Type Definition',
        },

        {
          'gi',
          function()
            Snacks.picker.lsp_implementations()
          end,
          desc = 'LSP: Goto Implementation',
        },

        {
          'gr',
          function()
            Snacks.picker.lsp_references()
          end,
          desc = 'LSP: Goto References',
        },
        --}}}

        {
          '<D-p>',
          function()
            Snacks.picker.git_files({
              untracked = true,
            })
          end,
          mode = { 'n', 'i', 'x' },
          desc = 'Search Files',
        },

        -- {
        --   '<leader>sa',
        --   function()
        --     Snacks.picker.files()
        --   end,
        --   desc = 'Search All files',
        -- },
        --
        {
          '<D-f>',
          function()
            Snacks.picker.lines({
              matcher = {
                fuzzy = true,
                ignorecase = true,
                smartcase = true,
              },
              layout = {
                preview = true,

                layout = {
                  backdrop = false,
                  width = 0.7,
                  min_width = 80,
                  height = 0.8,
                  min_height = 30,
                  box = 'vertical',
                  border = 'rounded',
                  title = '{title} {live} {flags}',
                  title_pos = 'center',
                  { win = 'preview', title = '{preview}', height = 0.6, border = 'bottom' },
                  { win = 'input', height = 1, border = 'bottom' },
                  { win = 'list', border = 'none' },
                },
              },
            })
          end,
          mode = { 'n', 'i', 'x' },
        },

        {
          '<D-o>',
          function()
            Snacks.picker.buffers({
              current = false,
            })
          end,
          mode = { 'n', 'i', 'x' },
          desc = 'Search Buffers',
        },

        {
          '<leader>sh',
          function()
            Snacks.picker.help()
          end,
          desc = 'Search Help',
        },
        {
          '<leader>sd',
          function()
            Snacks.picker.diagnostics()
          end,
          desc = 'Search Diagnostics',
        },
        {
          '<leader>sw',
          function()
            Snacks.picker.grep_word()
          end,
          desc = 'Search Word',
        },

        utils.cmd_shift('r', {
          function()
            Snacks.picker.resume()
          end,
          desc = 'Snacks Resume',
        }),

        utils.cmd_shift('p', {
          function()
            Snacks.picker()
          end,
          desc = 'Snacks',
        }),

        {
          '<leader>S.',
          function()
            Snacks.scratch()
          end,
          desc = 'Toggle Scratch Buffer',
        },
        {
          '<leader>SS',
          function()
            Snacks.scratch.select()
          end,
          desc = 'Select Scratch Buffer',
        },
        {
          '<leader>n',
          function()
            Snacks.notifier.show_history()
          end,
          desc = 'Notification History',
        },
        {
          '<leader>un',
          function()
            Snacks.notifier.hide()
          end,
          desc = 'Dismiss All Notifications',
        },
      }
    end,
  },
}
