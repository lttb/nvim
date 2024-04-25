-- vim:fileencoding=utf-8:foldmethod=marker

-- cSpell:words cssls jsonls lspsaga

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  local lsp_zero = require('lsp-zero')

  lsp_zero.extend_lspconfig()

  require('neoconf').setup({})

  require('typescript-tools').setup({
    settings = {
      expose_as_code_action = 'all',

      complete_function_calls = true,

      jsx_close_tag = {
        enable = true,
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

  lsp_zero.on_attach(function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

  lsp_zero.setup()

  -- require('lttb.dev.lsp_code_filter').setup()

  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = { 'rust_analyzer', 'lua_ls', 'cssls', 'eslint', 'html', 'jsonls' },
    handlers = {
      lsp_zero.default_setup,
      tsserver = lsp_zero.noop,
      lua_ls = function()
        local lua_opts = lsp_zero.nvim_lua_ls()
        require('lspconfig').lua_ls.setup(lua_opts)
      end,
    },
  })

  require('lsp-zero').extend_cmp()

  local cmp = require('cmp')
  local cmp_format = require('lsp-zero').cmp_format()
  local cmp_action = require('lsp-zero').cmp_action()

  cmp.setup({
    formatting = cmp_format,

    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<Tab>'] = cmp_action.luasnip_supertab(),
      ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    }),

    experimental = {
      ghost_text = true, -- this feature conflict with copilot.vim's preview.
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      { { name = 'path' } },
      { { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } } }
    ),
  })
end

return {
  { 'folke/neodev.nvim', opts = {} },
  { 'folke/neoconf.nvim' },

  {
    'VonHeikemen/lsp-zero.nvim',
    lazy = false,
    priority = 10,
    keys = {
      { '<D-.>', vim.lsp.buf.code_action, desc = 'Code Action' },
      -- { '<F-2>', vim.lsp.buf.rename, desc = 'Rename Symbol' },
    },
    branch = 'v3.x',
    config = config,
    dependencies = {
      {
        'hrsh7th/nvim-cmp',
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
          'L3MON4D3/LuaSnip',
        },
      },

      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      'neovim/nvim-lspconfig',

      {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        config = false,
      },
      {
        'nvimdev/lspsaga.nvim',
        enabled = false,
        keys = {
          { '<D-.>', '<cmd>Lspsaga code_action<cr>', mode = { 'n', 'v' } },
          { 'K', '<cmd>Lspsaga hover_doc<cr>' },
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
        'aznhe21/actions-preview.nvim',
        enabled = false,
        config = function()
          vim.keymap.set({ 'v', 'n' }, '<D-.>', require('actions-preview').code_actions)
        end,
      },

      {
        'weilbith/nvim-code-action-menu',
        enabled = false,
        cmd = 'CodeActionMenu',
        config = function()
          vim.g.code_action_menu_show_diff = true
        end,
      },

      {
        'antosha417/nvim-lsp-file-operations',
        enabled = false,
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
    },
  },
}
