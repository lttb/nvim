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
    event = 'LazyFile',
    keys = {
      -- ghostty doesn't support <D-.>
      { '<C-.>', vim.lsp.buf.code_action, desc = 'Code Action' },
      -- { '<F-2>', vim.lsp.buf.rename, desc = 'Rename Symbol' },
    },
    branch = 'v3.x',
    config = config,
    dependencies = {
      {
        'saghen/blink.cmp',
        event = 'LazyFile',
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
              selection = function(ctx)
                return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
              end,
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

            cmdline = {
              preset = 'super-tab',
            },
          },
        },
      },

      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      'neovim/nvim-lspconfig',


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
        event = 'LazyFile',
      },

      {
        'lukas-reineke/lsp-format.nvim',
        event = 'LazyFile',
      },
    },
  },
}
