local utils = require('lttb.utils')
local theme = require('lttb.theme')

if utils.is_vscode() then
  return {}
end

return {
  {
    'lewis6991/hover.nvim',
    config = function()
      require('hover').setup({
        init = function()
          require('hover.providers.lsp')
          require('hover.providers.gh')
          require('hover.providers.gh_user')
          require('hover.providers.jira')
          require('hover.providers.man')
          require('hover.providers.dictionary')
        end,
      })

      utils.keyplug('lttb-lsp-hover', require('hover').hover, {
        desc = 'hover.nvim',
      })
      utils.keyplug('lttb-lsp-hover-select', require('hover').hover_select, {
        desc = 'hover.nvim (select)',
      })
    end,
  },

  {
    'zbirenbaum/neodim',
    event = 'LspAttach',
    opts = {
      alpha = 0.5,
      blend_color = theme.variant == 'dark' and '#2a2c3c' or '#f0f0f0',
    },
    enabled = theme.name ~= 'github',
  },

  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = function()
      vim.g.code_action_menu_show_diff = true
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'VimEnter',
    config = true,
  },

  {
    'windwp/nvim-autopairs',
    event = 'VimEnter',
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local npairs = require('nvim-autopairs')

      npairs.setup({
        check_ts = true,
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  {
    'axelvc/template-string.nvim',
    event = 'VimEnter',
    config = true,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'VimEnter',
    config = function()
      vim.defer_fn(function()
        require('copilot').setup({
          panel = {
            auto_refresh = true,
          },

          suggestion = {
            auto_trigger = true,
            accept = false,
          },

          filetypes = {
            ['*'] = true,
          },

          -- NOTE: it has to be node v16
          -- @see https://github.com/zbirenbaum/copilot.lua/issues/69
          -- Check later if it works with v18
          copilot_node_command = 'node',
        })
      end, 100)
    end,
    -- NOTE: error "client quit with exit code 0 and signal"
    -- TODO: investigate and raise an issue
    -- enabled = not utils.is_neovide(),
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      local indent_char = false and utils.is_neovide() and '·' or '┊'

      require('indent_blankline').setup({
        char = indent_char,
        context_char = indent_char,
        show_trailing_blankline_indent = false,
        show_current_context = true,
        show_first_indent_level = false,
      })
    end,
  },

  {
    -- TODO: review this plugin, not sure I'll keep it
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = { 'json' },
    config = function()
      local package_info = require('package-info')
      local gs = package.loaded.gitsigns

      package_info.setup({
        autostart = false,
        hide_up_to_date = true,
      })

      vim.api.nvim_create_user_command('NpmInstall', function()
        package_info.install()
      end, {})

      vim.api.nvim_create_user_command('NpmDelete', function()
        package_info.delete()
      end, {})

      vim.api.nvim_create_user_command('NpmToggle', function()
        gs.toggle_current_line_blame()
        package_info.toggle()
      end, {})

      vim.api.nvim_create_user_command('NpmUpdate', function()
        package_info.update()
      end, {})

      vim.api.nvim_create_user_command('NpmVersion', function()
        package_info.change_version()
      end, {})
    end,
  },

  {
    'windwp/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local spectre = require('spectre')

      spectre.setup({
        live_update = true,
        is_insert_mode = true,
      })

      utils.keyplug('lttb-spectre', spectre.open, {
        desc = 'spectre.nvim',
      })

      utils.keyplug('lttb-spectre-search-in-file', spectre.open_file_search, {
        desc = 'spectre.nvim | search in file',
      })

      utils.keyplug('lttb-spectre-search-word', function()
        spectre.open_visual({ select_word = true })
      end, {
        desc = 'spectre.nvim | search word',
      })

      utils.keyplug('lttb-spectre-open-visual', function()
        spectre.open_visual({ select_word = true })
      end, {
        desc = 'spectre.nvim | open visual',
      })
    end,
  },

  {
    'smjonas/live-command.nvim',
    config = function()
      require('live-command').setup({
        commands = {
          Norm = { cmd = 'norm' },
        },
      })
    end,
  },
}
