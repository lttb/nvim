local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

return {
  {
    enabled = true,
    'nmac427/guess-indent.nvim',
    opts = {},
  },

  {
    enabled = false,
    'vidocqh/auto-indent.nvim',
    opts = {
      lightmode = false,
      ---@param lnum: number
      ---@return number
      indentexpr = function(lnum)
        return require('nvim-treesitter.indent').get_indent(lnum)
      end,
    },
  },

  {
    enabled = false,
    'kawre/neotab.nvim',
    event = 'InsertEnter',
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'VimEnter',
    config = true,
  },

  {
    'windwp/nvim-autopairs',
    event = 'VimEnter',
    config = function()
      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')

      npairs.setup({
        check_ts = true,
        break_undo = true,
        map_c_h = true,
        map_c_w = true,

        -- support coq
        -- map_bs = false,
        -- map_cr = false,
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      npairs.add_rules({
        Rule('**', '**', { 'markdown', 'mdx' }),
        Rule('```', '```', { 'mdx' }),
        Rule('```.*$', '```', { 'mdx' }):only_cr():use_regex(true),
      })
    end,
  },

  {
    enabled = false,
    'altermo/ultimate-autopair.nvim',
    -- TODO: check the config - so far it's not really convinient to insert/delete pairs to wrap expressions
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6',
    opts = {},
  },

  {
    'axelvc/template-string.nvim',
    event = 'VimEnter',
    config = true,
  },

  {
    enabled = false,
    'zbirenbaum/copilot.lua',
    -- NOTE: error "client quit with exit code 0 and signal"
    -- TODO: investigate and raise an issue
    -- enabled = not utils.is_neovide(),
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
  },

  {
    -- TODO: review this plugin, not sure I'll keep it
    enabled = false,
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
    enabled = false,
    'smjonas/live-command.nvim',
    keys = {
      { '<leader>l', ':Norm', desc = 'Live Command' },
    },
    config = function()
      require('live-command').setup({
        commands = {
          Norm = { cmd = 'norm' },
        },
      })
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    opts = {},
  },

  {
    -- NOTE: it's quite slow on the startup, and blocks neo-tree
    enabled = false,
    'coffebar/neovim-project',
    lazy = false,
    priority = 100,
    opts = {
      projects = { -- define project roots
        '~/dev/work/*',
        '~/dev/oss/*',
        '~/.config/*',
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append('globals') -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim', tag = '0.1.4' },
      { 'Shatur/neovim-session-manager' },
    },
  },

  {
    enabled = false,
    'jedrzejboczar/possession.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      autosave = {
        current = true,
        tmp = true,
      },
    },
  },

  -- {
  --   'JoosepAlviste/nvim-ts-context-commentstring',
  -- },

  -- {
  --   'numToStr/Comment.nvim',
  --   config = function()
  --     require('Comment').setup({
  --       ignore = '^$',
  --       pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  --     })
  --   end,
  -- },

  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },

  {
    -- feels quite buggy, disable for now
    enabled = false,
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
  },

  -- NOTE: consider alternative https://github.com/chrisgrieser/nvim-early-retirement
  {
    enabled = false,
    'axkirillov/hbac.nvim',
    opts = {},
  },

  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.97,
      },
    },
  },

  { 'knubie/vim-kitty-navigator' },

  -- better quick fix window
  { 'kevinhwang91/nvim-bqf' },

  { 'LunarVim/bigfile.nvim' },

  {
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
}
