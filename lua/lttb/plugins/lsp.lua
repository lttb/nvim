-- vim:fileencoding=utf-8:foldmethod=marker

-- cSpell:words cssls jsonls lspsaga

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  --- @type vim.diagnostic.Opts.VirtualText
  local virtual_text_settings = {
    enabled = false,
    severity = { min = vim.diagnostic.severity.ERROR },
    source = false,
    spacing = 1,
  }

  -- @see https://github.com/nvim-lua/kickstart.nvim/blob/a8f539562a8c5d822dd5c0ca1803d963c60ad544/init.lua#L471
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local is_virtual_text_enabled = true
      vim.keymap.set('n', '<leader>D', function()
        is_virtual_text_enabled = not is_virtual_text_enabled

        vim.diagnostic.config({
          virtual_text = is_virtual_text_enabled and virtual_text_settings or false,
        })
      end, { desc = 'Enable Virtual Text' })

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      -- local client = vim.lsp.get_client_by_id(event.data.client_id)
      -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      --   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      --     buffer = event.buf,
      --     group = highlight_augroup,
      --     callback = vim.lsp.buf.document_highlight,
      --   })
      --
      --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      --     buffer = event.buf,
      --     group = highlight_augroup,
      --     callback = vim.lsp.buf.clear_references,
      --   })
      --
      --   vim.api.nvim_create_autocmd('LspDetach', {
      --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      --     callback = function(event2)
      --       vim.lsp.buf.clear_references()
      --       vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
      --     end,
      --   })
      -- end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      --   map('<leader>th', function()
      --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      --   end, '[T]oggle Inlay [H]ints')
      -- end
    end,
  })

  vim.diagnostic.config({
    update_in_insert = false,

    virtual_text = virtual_text_settings,

    signs = (function()
      -- Highlight line number instead of having icons in sign column
      -- @see https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#highlight-line-number-instead-of-having-icons-in-sign-column
      local signs_map = {}
      for _, diag in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
        local hl = 'DiagnosticSign' .. diag
        signs_map[hl] = { text = '', texthl = hl, linehl = '', numhl = hl }
      end
      return signs_map
    end)(),
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. Available keys are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --  - settings (table): Override the default settings passed when initializing the server.
  --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- But for many setups, the LSP (`ts_ls`) will work just fine
    -- ts_ls = {},
    --

    lua_ls = {
      -- cmd = { ... },
      -- filetypes = { ... },
      -- capabilities = {},
      settings = {
        Lua = {
          -- NOTE: it seems a bit slow
          -- diagnostics = { neededFileStatus = { ['codestyle-check'] = 'Any' } },
          -- NOTE: You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
          completion = { callSnippet = 'Replace' },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },

          workspace = {
            checkThirdParty = false,
          },
        },
      },
    },

    marksman = {
      settings = {},
    },

    ts_ls = {
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    },

    jsonls = {
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,

      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    },

    yamlls = {
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
    },
  }

  for lsp_name, lsp_config in pairs(servers) do
    vim.lsp.config(lsp_name, lsp_config)
  end

  require('lttb.utils.lsp_code_filter').setup()

  -- Ensure the servers and tools above are installed
  --  To check the current status of installed tools and/or manually install
  --  other tools, you can run
  --    :Mason
  --
  --  You can press `g?` for help in this menu.
  require('mason').setup()

  -- You can add other tools here that you want Mason to install
  -- for you, so that they are available from within Neovim.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {})

  -- require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

  require('mason-lspconfig').setup({ ensure_installed = ensure_installed })
  -- require('mason-lspconfig').setup_handlers({
  --   -- The first entry (without a key) will be the default handler
  --   -- and will be called for each installed server that doesn't have
  --   -- a dedicated handler.
  --   function(server_name) -- default handler (optional)
  --     local server = servers[server_name] or {}
  --     -- This handles overriding only values explicitly passed
  --     -- by the server configuration above. Useful when disabling
  --     -- certain features of an LSP (for example, turning off formatting for ts_ls)
  --     server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  --
  --     -- if utils.is_dotfiles() then
  --     --   return
  --     -- end
  --
  --     require('lspconfig')[server_name].setup(vim.tbl_extend('keep', {
  --       on_attach = function(client, bufnr)
  --         if server.on_attach then
  --           server.on_attach(client, bufnr)
  --         end
  --
  --         -- client.server_capabilities.semanticTokensProvider = nil
  --       end,
  --     }, server))
  --   end,
  -- })

  require('lspconfig').prettier_ls.setup({})
  require('lspconfig').gh_actions_ls.setup({})
  require('lspconfig').cspell_ls.setup({
    handlers = {
      ['textDocument/publishDiagnostics'] = function(err, result, ctx, conf)
        vim.tbl_map(function(d)
          d.severity = vim.diagnostic.severity.INFO
        end, result.diagnostics or {})
        vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, conf)
      end,
    },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      if client == nil then
        return
      end

      if client.name == 'biome' then
        vim.b.ls_biome = { client = client }

        if vim.b.ls_prettier_ls then
          vim.b.ls_prettier_ls.client.stop()
        end
      elseif client.name == 'prettier_ls' then
        vim.b.ls_prettier_ls = { client = client }

        if vim.b.ls_biome ~= nil then
          client.stop()

          return
        end
      end
    end,
  })
end

return {
  -- { 'folke/neodev.nvim', opts = {} },
  -- { 'folke/neoconf.nvim' },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
    dependencies = {
      { 'Bilal2453/luvit-meta', lazy = true },
    },
  },

  {
    'neovim/nvim-lspconfig',
    -- it has to be VeryLazy or not lazy at all, otherwise LSP get stuck a bit
    event = 'VeryLazy',
    keys = {
      -- ghostty doesn't support <D-.>
      { '<D-.>', vim.lsp.buf.code_action, desc = 'Code Action', mode = { 'n', 'i', 'x' } },
      -- { '<F-2>', vim.lsp.buf.rename, desc = 'Rename Symbol' },
    },
    config = config,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      {
        'smjonas/inc-rename.nvim',
        config = function()
          require('inc_rename').setup({})
        end,
        keys = {
          { '<F2>', ':IncRename ' },
        },
      },

      {
        'b0o/schemastore.nvim',
      },

      {
        enabled = false,
        'lukas-reineke/lsp-format.nvim',
      },
    },
  },
}
