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

local packer_util = require('packer.util')

require('packer').startup({
  function(use)
    use({
      'wbthomason/packer.nvim',
      'lewis6991/impatient.nvim',
      'nvim-lua/plenary.nvim',
    })

    -- Treesitter {{{
    use({
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/playground',
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
    use({
      'nvim-treesitter/nvim-treesitter-context',
      after = 'nvim-treesitter',
      config = function()
        require('treesitter-context').setup()

        local theme = require('lttb.theme')

        if theme.colorscheme == 'github_light' then
          -- NOTE: for some reason nvim_set_hl didn't override
          vim.cmd([[
          hi! link TreesitterContext CursorLineFold
        ]])
        end
      end,
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

        vim.keymap.set('', 's', function()
          leap.leap({
            target_windows = { vim.fn.win_getid() },

            opts = {
              equivalence_classes = {
                '\t\r\n',
                ')]}>',
                '([{<',
                { '"', "'", '`' },
              },
            },
          })
        end, {
          silent = true,
        })
      end,
    })

    use({
      'ggandor/leap-spooky.nvim',
      requires = {
        'ggandor/leap.nvim',
      },
      config = function()
        require('leap-spooky').setup({})
      end,
    })

    use({
      'ggandor/flit.nvim',
      requires = {
        'ggandor/leap.nvim',
      },
      config = function()
        require('flit').setup()
      end,
    })

    use({
      'gbprod/substitute.nvim',
      config = function()
        local substitute = require('substitute')
        substitute.setup({})

        local utils = require('lttb.utils')

        utils.keyplug('lttb-substiture-operator', substitute.operator)
        utils.keyplug('lttb-substiture-line', substitute.line)
        utils.keyplug('lttb-substiture-eol', substitute.eol)
        utils.keyplug('lttb-substiture-visual', substitute.visual)
      end,
    })

    use({
      'phaazon/hop.nvim',
      branch = 'v2',
      config = function()
        local hop = require('hop')

        hop.setup({
          jump_on_sole_occurrence = true,
        })

        local utils = require('lttb.utils')

        utils.keyplug('lttb-hop-on', function()
          hop.hint_char1({
            current_line_only = false,
          })
        end)

        utils.keyplug('lttb-hop-pre', function()
          hop.hint_char1({
            current_line_only = false,
            hint_offset = -1,
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

        require('mini.align').setup({})

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

    use_nvim({ 'tpope/vim-sleuth' })

    use_nvim({
      'kyazdani42/nvim-web-devicons',
    })

    use_nvim({
      'folke/which-key.nvim',
      config = function()
        require('which-key').setup({})
      end,
      -- NOTE: causes freezes with insert mode: <C-O>"+p
      disable = true,
    })

    use_nvim({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    })

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

          'lukas-reineke/cmp-rg',
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
            panel = {
              auto_refresh = true,
            },

            suggestion = {
              auto_trigger = true,
              keymap = {
                accept = '<C-l>',
              },
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
    })

    -- use_nvim({
    --   'zbirenbaum/copilot-cmp',
    --   after = { 'copilot.lua' },
    --   config = function()
    --     require('copilot_cmp').setup()
    --   end,
    -- })

    use_nvim({
      'abecodes/tabout.nvim',
      config = function()
        require('tabout').setup({})
      end,
      wants = { 'nvim-treesitter' }, -- or require if not used so far
      after = { 'nvim-cmp' }, -- if a completion plugin is using tabs load it before
      -- NOTE: going to remove
      disable = true,
    })

    use_nvim({
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        local utils = require('lttb.utils')
        local indent_char = false and utils.is_neovide() and '·' or '┊'

        require('indent_blankline').setup({
          char = indent_char,
          context_char = indent_char,
          show_trailing_blankline_indent = false,
          show_current_context = true,
          show_first_indent_level = false,
        })
      end,
    })
    -- }}}

    use_nvim({
      'kyazdani42/nvim-tree.lua',
      config = function()
        require('lttb.plugins.nvim-tree')
      end,
    })

    use_nvim({
      'nvim-lualine/lualine.nvim',
      -- after = { 'github-nvim-theme' },
      config = function()
        require('lttb.plugins.lualine')
      end,
    })

    use_nvim({
      'RRethy/vim-illuminate',
      config = function()
        -- <a-n> and <a-p> as keymaps to move between references
        -- and <a-i> as a textobject for the reference illuminated under the cursor.
        -- vim.api.nvim_set_hl(
        --   0,
        --   'IlluminatedWordText',
        --   { link = 'LspReferenceText' }
        -- )
        -- vim.api.nvim_set_hl(
        --   0,
        --   'IlluminatedWordRead',
        --   { link = 'LspReferenceText' }
        -- )
        -- vim.api.nvim_set_hl(
        --   0,
        --   'IlluminatedWordWrite',
        --   { link = 'LspReferenceText' }
        -- )

        require('illuminate').configure({
          modes_denylist = { 'i' },
        })
      end,
      -- WARN: candidate to remove, as "mini.cursorword" feels better
      disable = true,
    })

    use_nvim({
      'projekt0n/github-nvim-theme',
      config = function()
        local theme = require('lttb.theme')
        local utils = require('lttb.utils')

        require('github-theme').setup({
          theme_style = theme.current.github_theme.theme_style,
          colors = theme.current.github_theme.colors,
          overrides = theme.current.github_theme.overrides,

          -- dark_float = not utils.is_neovide(),
          -- dark_sidebar = not utils.is_neovide(),
          dark_float = true,
          dark_sidebar = false,
          keyword_style = 'NONE',
          transparent = false,
          sidebars = { 'qf', 'vista_kind', 'terminal', 'packer', 'cmdline' },
        })

        vim.cmd.colorscheme(theme.colorscheme)
      end,

      disable = false,
    })

    -- use_nvim({
    --   'lourenci/github-colors',
    --   config = function()
    --     vim.cmd.colorscheme('github-colors')
    --   end,
    -- })

    use_nvim({
      'catppuccin/nvim',
      as = 'catppuccin',
      config = function()
        local theme = require('lttb.theme')

        require('catppuccin').setup({
          flavour = 'frappe',

          term_colors = true,
          no_italic = true,
          no_bold = true,
          dim_inactive = {
            enabled = true,
          },

          custom_highlights = {
            -- IndentBlanklineChar = {
            --   fg = '#2f363d',
            -- },

            -- IndentBlanklineContextChar = {
            --   fg = '#383f46',
            -- },
          },

          integrations = {
            hop = true,

            indent_blankline = {
              enabled = true,
            },

            leap = true,
            mason = true,

            native_lsp = {
              enabled = true,
            },

            illuminate = true,

            mini = true,
          },
        })

        vim.cmd.colorscheme('catppuccin')
      end,

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
          max_length = 150,
          always_scroll = true,
        })
      end,
      cond = function()
        return not require('lttb.utils').is_neovide()
      end,
    })

    use_nvim({
      'akinsho/toggleterm.nvim',
      tag = '*',
      config = function()
        require('toggleterm').setup({
          open_mapping = [[<C-j>]],
          direction = 'float',
          close_on_exit = false,
        })
      end,

      -- NOTE: disable in favor of FTerm
      disable = true,
    })

    use_nvim({
      'numToStr/FTerm.nvim',
      config = function()
        require('FTerm').setup({
          auto_close = true,
        })

        local utils = require('lttb.utils')

        utils.keyplug('lttb-toggle-term', function()
          require('FTerm').toggle()
        end)
      end,
    })

    use_nvim({
      'folke/noice.nvim',
      config = function()
        require('noice').setup({
          -- messages = {
          --   view_warn = 'mini',
          --   view_error = 'mini',
          -- },
        })
      end,
      requires = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        'MunifTanjim/nui.nvim',
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        -- 'rcarriga/nvim-notify',
      },
      -- cond = function()
      --   return not require('lttb.utils').is_neovide()
      -- end,
      -- NOTE: a bit distracting, check it later
      disable = false,
    })

    use_nvim({
      'cbochs/portal.nvim',
      config = function()
        require('portal').setup({})

        vim.keymap.set('n', '<leader>o', require('portal').jump_backward, {})
        vim.keymap.set('n', '<leader>i', require('portal').jump_forward, {})
      end,
      -- NOTE: not sure if I need it
      disable = true,
    })

    -- Telescope {{{
    use_nvim({
      'nvim-telescope/telescope.nvim',
      config = function()
        require('lttb.plugins.telescope')
      end,
    })

    use_nvim({
      'nvim-telescope/telescope-fzf-native.nvim',
      -- @see https://github.com/nvim-telescope/telescope-fzf-native.nvim#cmake-windows-linux-macos
      -- run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      run = 'make',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('fzf')
      end,
    })

    -- }}}

    use_nvim({
      'natecraddock/workspaces.nvim',
      config = function()
        local workspaces = require('workspaces')

        workspaces.setup({
          global_cd = true,

          hooks = {
            open_pre = function()
              -- Close buffers
              vim.cmd('%bdelete')
            end,

            open = {
              'NvimTreeOpen',
            },
          },
        })
      end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    snapshot_path = packer_util.join_paths(
      vim.fn.stdpath('config'),
      'snapshots'
    ),
  },
})

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

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', {
  clear = true,
})
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand('$MYVIMRC'),
})
