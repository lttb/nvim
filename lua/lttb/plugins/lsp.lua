-- vim:fileencoding=utf-8:foldmethod=marker

-- cSpell:words cssls jsonls lspsaga

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  local lsp_zero = require('lsp-zero')

  require('lsp-format').setup()

  lsp_zero.on_attach(function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil

    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })

    if client.name == 'ts_ls' then
      return
    end

    lsp_zero.buffer_autoformat()
  end)

  local lspconfig_defaults = require('lspconfig').util.default_config
  lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('blink.cmp').get_lsp_capabilities()
  )

  lsp_zero.extend_lspconfig({
    sign_text = true,
  })



  -- require('neoconf').setup({})

  -- require('typescript-tools').setup({
  --   settings = {
  --     expose_as_code_action = 'all',
  --
  --     complete_function_calls = true,
  --
  --     jsx_close_tag = {
  --       enable = true,
  --     },
  --   },
  -- })

  -- require('lspconfig.configs').vtsls = require('vtsls').lspconfig

  require('lspconfig').jsonls.setup({
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  })

  require('lspconfig').yamlls.setup({
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = '',
        },
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  })

  vim.diagnostic.config({
    update_in_insert = false,

    virtual_text = {
      severity = { min = vim.diagnostic.severity.ERROR },
      source = false,
      spacing = 1,
    },
  })

  -- lsp_zero.configure('lua_ls', {
  --   settings = {
  --     Lua = {
  --       format = {
  --         enable = true,
  --         defaultConfig = {
  --           indent_style = 'space',
  --           indent_size = '2',
  --         },
  --       },
  --       -- NOTE: it seems a bit slow
  --       -- diagnostics = { neededFileStatus = { ['codestyle-check'] = 'Any' } },
  --       completion = { callSnippet = 'Replace' },
  --       -- Do not send telemetry data containing a randomized but unique identifier
  --       telemetry = { enable = false },

  --       workspace = {
  --         checkThirdParty = false,
  --       },
  --     },
  --   },
  -- })

  require('lspconfig').biome.setup({})

  -- lsp_zero.configure('tsserver', {
  --   on_attach = function(client)
  --     -- this is important, otherwise tsserver will format ts/js
  --     -- files which we *really* don't want.
  --     client.server_capabilities.documentFormattingProvider = false
  --   end,
  -- })


  lsp_zero.setup()

  require('lttb.dev.lsp_code_filter').setup()

  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = { 'rust_analyzer', 'lua_ls', 'cssls', 'html', 'jsonls' },
    handlers = {
      lsp_zero.default_setup,
      lua_ls = function()
        local lua_opts = lsp_zero.nvim_lua_ls()
        require('lspconfig').lua_ls.setup(lua_opts)
      end,
    },
  })

  -- require('lttb.plugins._cmp').setup()
  --   require('lsp-zero').extend_cmp()
end

return {
  -- { 'folke/neodev.nvim', opts = {} },
  -- { 'folke/neoconf.nvim' },

  {
    'VonHeikemen/lsp-zero.nvim',
    lazy = false,
    priority = 10,
    keys = {
      -- ghostty doesn't support <D-.>
      { '<C-.>', vim.lsp.buf.code_action, desc = 'Code Action' },
      -- { '<F-2>', vim.lsp.buf.rename, desc = 'Rename Symbol' },
    },
    branch = 'v3.x',
    config = config,
    dependencies = {
      {
        -- 'hrsh7th/nvim-cmp',
        enabled = false,
        'yioneko/nvim-cmp',
        branch = 'perf',
        dependencies = {
          'VonHeikemen/lsp-zero.nvim',

          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/nvim-cmp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-cmdline',
          -- lags on large projects
          -- 'lukas-reineke/cmp-rg',
          'onsails/lspkind.nvim',
          {

            'L3MON4D3/LuaSnip',
            version = 'v2.*',
            build = 'make install_jsregexp',
          },
        },
        opts = {
          performance = {
            debounce = 0, -- default is 60ms
            throttle = 0, -- default is 30ms
          },
        },
      },

      {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        version = '*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
          completion = {
            ghost_text = { enabled = true },

            list = {
              selection = 'auto_insert',
            },

            menu = {
              cmdline_position = function()
                if vim.g.ui_cmdline_pos ~= nil then
                  local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                  return { pos[1] - 1, pos[2] }
                end
                local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                return { vim.o.lines - height, 0 }
              end,
            },
          },

          keymap = {
            preset = 'super-tab',

            ['<CR>'] = { 'select_and_accept', 'fallback' },
          },
        },
      },

      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      'neovim/nvim-lspconfig',

      {
        enabled = false,
        'yioneko/nvim-vtsls',
      },

      {
        enabled = false,
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        config = false,
      },
      {
        enabled = false,
        'nvimdev/lspsaga.nvim',
        keys = {
          { '<D-.>', '<cmd>Lspsaga code_action<cr>', mode = { 'n', 'v' } },
          { 'K',     '<cmd>Lspsaga hover_doc<cr>' },
          -- { '<F2>', '<cmd>Lspsaga rename<cr>' },
        },
        config = function()
          require('lspsaga').setup({
            ui = { code_action = '', border = 'rounded' },
            hover = { max_width = 0.4 },
            rename = { keys = { quit = '<ESC>' } },

            lightbulb = { enable = false },
            symbol_in_winbar = { enable = false },
            implement = { enable = false },
            beacon = { enable = false },
          })
        end,
      },

      { enabled = false, 'hinell/lsp-timeout.nvim', dependencies = { 'neovim/nvim-lspconfig' } },

      {
        enabled = false,
        'aznhe21/actions-preview.nvim',
        config = function()
          vim.keymap.set({ 'v', 'n' }, '<D-.>', require('actions-preview').code_actions)
        end,
      },

      {
        enabled = false,
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
        config = function()
          vim.g.code_action_menu_show_diff = true
        end,
      },

      {
        enabled = false,
        'antosha417/nvim-lsp-file-operations',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-neo-tree/neo-tree.nvim',
        },
        config = function()
          require('lsp-file-operations').setup()
        end,
      },

      {
        'smjonas/inc-rename.nvim',
        config = function()
          require('inc_rename').setup()
        end,
        keys = {
          { '<F2>', ':IncRename ' },
        },
      },

      {
        'b0o/schemastore.nvim',
      },

      {
        'lukas-reineke/lsp-format.nvim',
      },
    },
  },
}
