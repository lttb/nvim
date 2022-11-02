-- vim:fileencoding=utf-8:foldmethod=marker

-- Install packer {{{
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')
    .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
-- }}}

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use({
    'wbthomason/packer.nvim',
    'lewis6991/impatient.nvim',
    'nvim-lua/plenary.nvim',
  })

  -- Treesitter {{{
  use({
    'nvim-treesitter/nvim-treesitter',
    -- run = ':TSUpdate',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  })
  use({
    'nvim-treesitter/nvim-treesitter-textobjects',
  })
  use({
    'RRethy/nvim-treesitter-textsubjects',
  })
  -- }}}

  use({
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({})
    end,
  })

  use({
    'ggandor/leap.nvim',
    config = function()
      local leap = require('leap')
      leap.set_default_keymaps()

      vim.keymap.set({ 'n' }, '<Plug>(leap-forward)', function()
        leap.leap({
          target_windows = { vim.fn.win_getid() },
        })
      end, {
        silent = true,
      })
    end,
  })

  use({
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      local hop = require('hop')
      local hop_hint = require('hop.hint')

      hop.setup()

      vim.keymap.set('', 'f', function()
        hop.hint_char1({
          current_line_only = false,
        })
      end)

      vim.keymap.set('', 'F', function()
        hop.hint_char1({
          current_line_only = false,
        })
      end)

      vim.keymap.set('', 't', function()
        hop.hint_char1({
          current_line_only = false,
          hint_offset = -1,
        })
      end)

      vim.keymap.set('', 'T', function()
        hop.hint_char1({
          current_line_only = false,
          hint_offset = 1,
        })
      end)
    end,
  })

  use({
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup({
        search_method = 'cover_or_nearest',
      })

      if require('lttb.utils').is_vscode() then
        return
      end

      require('mini.cursorword').setup({})

      local MiniMap = require('mini.map')

      MiniMap.setup({
        integrations = {
          MiniMap.gen_integration.builtin_search(),
          MiniMap.gen_integration.gitsigns(),
        },
        symbols = {
          encode = MiniMap.gen_encode_symbols.dot('3x2'),
          scroll_line = '▶ ',
          scroll_view = '┃ ',
        },

        window = {
          show_integration_count = false,
        },
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          MiniMap.open({})
        end,
      })
    end,
  })

  use({
    'ibhagwan/smartyank.nvim',
    config = function()
      require('smartyank').setup({
        highlight = {
          enabled = true, -- highlight yanked text
          higroup = 'Search', -- highlight group of yanked text
          timeout = 200, -- timeout for clearing the highlight
        },
        clipboard = {
          enabled = true,
        },
        tmux = {
          enabled = true,
          -- remove `-w` to disable copy to host client's clipboard
          cmd = { 'tmux', 'set-buffer', '-w' },
        },
        osc52 = {
          enabled = true,
          ssh_only = true, -- false to OSC52 yank also in local sessions
          silent = false, -- true to disable the "n chars copied" echo
          echo_hl = 'Directory', -- highlight group of the OSC52 echo message
        },
      })
    end,
  })

  if require('lttb.utils').is_vscode() then
    require('lttb.vscode')

    return
  end

  if require('lttb.utils').is_neovide() then
    require('lttb.neovide')
  end

  -- nvim only

  local use_nvim = function(plugin)
    use(vim.tbl_extend('keep', plugin, {
      cond = function()
        return not require('lttb.utils').is_vscode()
      end,
    }))
  end

  use({
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({})
    end,
  })

  use_nvim({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  })

  use_nvim({ 'tpope/vim-sleuth' })

  -- Git {{{
  use_nvim({
    'tpope/vim-fugitive',
    event = 'VimEnter',
  })

  use_nvim({
    'tpope/vim-rhubarb',
    event = 'VimEnter',
  })

  use_nvim({
    'lewis6991/gitsigns.nvim',
    event = 'VimEnter',
    config = function()
      require('gitsigns').setup()
    end,
  })

  use_nvim({
    'f-person/git-blame.nvim',
    config = function()
      vim.g.gitblame_display_virtual_text = 1

      require('lttb.utils').hl_create('GitBlameInline')
      vim.g.gitblame_highlight_group = 'GitBlameInline'

      vim.g.gitblame_set_extmark_options = {
        hl_mode = 'combine',
        hl_group = 'GitBlameInline',
      }
    end,
    -- WARN: candidate to remove, as it doesn't fit well
    -- Probably with delay it could be better
    disable = true,
  })

  -- }}}

  -- LSP and CMP {{{
  use_nvim({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    {
      'L3MON4D3/LuaSnip',
      requires = { 'saadparwaiz1/cmp_luasnip' },
    },
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',

        'onsails/lspkind.nvim',
        'L3MON4D3/LuaSnip',
      },
      config = function()
        require('lttb.plugins.lsp')
      end,
    },
  })

  use_nvim({
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('lttb.plugins.null-ls')
    end,
  })

  use_nvim({
    'windwp/nvim-ts-autotag',
    event = 'VimEnter',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  })

  use_nvim({
    'windwp/nvim-autopairs',
    event = 'VimEnter',
    config = function()
      local npairs = require('nvim-autopairs')

      npairs.setup({
        check_ts = true,
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  })

  use_nvim({
    'axelvc/template-string.nvim',
    event = 'VimEnter',
    config = function()
      require('template-string').setup()
    end,
  })

  use_nvim({
    'zbirenbaum/copilot.lua',
    event = 'VimEnter',
    config = function()
      vim.defer_fn(function()
        require('copilot').setup({
          suggestion = {
            auto_trigger = true,
            keymap = {
              accept = '<C-CR>',
            },
          },
        })
      end, 100)
    end,
  })

  use_nvim({
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup()
    end,
    wants = { 'nvim-treesitter' }, -- or require if not used so far
    after = { 'nvim-cmp' }, -- if a completion plugin is using tabs load it before
  })

  use_nvim({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char = '┊',
        show_trailing_blankline_indent = false,
        show_current_context = true,
        show_first_indent_level = false,
      })
    end,
  })
  -- }}}

  use_nvim({
    'kyazdani42/nvim-web-devicons',
  })

  use_nvim({
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('lttb.plugins.nvim-tree')

      local nt_api = require('nvim-tree.api')

      vim.keymap.set('n', '<leader>b', function()
        nt_api.tree.toggle(true, true)
      end, {
        silent = true,
      })

      vim.keymap.set('n', '<leader>e', function()
        nt_api.tree.focus()
      end, {
        silent = true,
      })
    end,
  })

  use_nvim({
    'nvim-lualine/lualine.nvim',
    after = { 'github-nvim-theme' },
    config = function()
      require('lttb.plugins.lualine')
    end,
  })

  use_nvim({
    'projekt0n/github-nvim-theme',
    config = function()
      require('github-theme').setup({
        theme_style = require('lttb.theme').current.github_theme.theme_style,
        colors = require('lttb.theme').current.github_theme.colors,
        overrides = require('lttb.theme').current.github_theme.overrides,

        dark_float = false,
        dark_sidebar = false,
        keyword_style = 'NONE',
        transparent = false,
      })
    end,
  })

  use_nvim({
    'RRethy/vim-illuminate',
    config = function()
      -- <a-n> and <a-p> as keymaps to move between references
      -- and <a-i> as a textobject for the reference illuminated under the cursor.
      vim.api.nvim_set_hl(
        0,
        'IlluminatedWordText',
        { link = 'LspReferenceText' }
      )
      vim.api.nvim_set_hl(
        0,
        'IlluminatedWordRead',
        { link = 'LspReferenceText' }
      )
      vim.api.nvim_set_hl(
        0,
        'IlluminatedWordWrite',
        { link = 'LspReferenceText' }
      )

      require('illuminate').configure({
        modes_denylist = { 'i' },
      })
    end,
    -- WARN: candidate to remove, as "mini.cursorword" feels better
    disable = true,
  })

  use_nvim({
    'declancm/cinnamon.nvim',
    config = function()
      require('cinnamon').setup({
        default_keymaps = true,
        extra_keymaps = true,
        extended_keymaps = true,

        hide_cursor = true,
        max_length = 50,
        always_scroll = true,
      })
    end,
    cond = function()
      return not require('lttb.utils').is_neovide()
    end,
  })

  -- Telescope {{{
  use_nvim({
    'nvim-telescope/telescope.nvim',
    config = function()
      local utils = require('lttb.utils')

      require('lttb.plugins.telescope').setup()

      utils.keyplug('lttb-telescope', '<cmd>Telescope<cr>')

      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, {
        desc = '[?] Find recently opened files',
      })

      vim.keymap.set('n', '<leader><space>', function()
        require('telescope.builtin').buffers({
          sort_mru = true,
          ignore_current_buffer = true,
        })
      end, {
        desc = '[ ] Find existing buffers',
      })

      utils.keyplug('lttb-search-buffer', function()
        require('telescope.builtin').current_buffer_fuzzy_find()
      end)

      vim.keymap.set('n', '<leader>sa', function()
        require('telescope.builtin').find_files({
          hidden = true,
          no_ignore = true,
        })
      end, {
        desc = '[S]earch [A]ll files',
      })

      vim.keymap.set('n', '<leader>ss', function()
        vim.fn.system('git rev-parse --is-inside-work-tree')

        if vim.v.shell_error == 0 then
          require('telescope.builtin').git_files({
            show_untracked = true,
            -- recurse_submodules = true,
          })
        else
          require('telescope.builtin').find_files({})
        end
      end, {
        desc = '[S]earch Files',
      })

      vim.keymap.set('n', '<leader>sf', function()
        require('telescope.builtin').git_files({
          recurse_submodules = true,
        })
      end, {
        desc = '[S]earch [F]iles Recurse Submodules',
      })

      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, {
        desc = '[S]earch [H]elp',
      })

      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, {
        desc = '[S]earch current [W]ord',
      })

      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, {
        desc = '[S]earch by [G]rep',
      })

      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, {
        desc = '[S]earch [D]iagnostics',
      })

      vim.keymap.set(
        'n',
        '<leader>sb',
        require('telescope.builtin').current_buffer_fuzzy_find,
        {
          desc = '[S]earch [B]buffer',
        }
      )
    end,
  })

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use_nvim({
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable('make') == 1,
  })
  -- }}}

  use_nvim({
    'folke/noice.nvim',
    config = function()
      require('noice').setup({
        messages = {
          view_warn = 'mini',
          view_error = 'mini',
        },
      })
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    cond = function()
      return not require('lttb.utils').is_neovide()
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if packer_bootstrap then
  print('==================================')
  print('    Plugins are being installed')
  print('    Wait until Packer completes,')
  print('       then restart nvim')
  print('==================================')
  return
end

require('lttb.plugins.treesitter').setup({})
