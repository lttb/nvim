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
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      local picker = require('snacks').picker

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>.
      map('gd', picker.lsp_definitions, '[G]oto [D]efinition')

      -- Find references for the word under your cursor.
      map('gr', picker.lsp_references, '[G]oto [R]eferences')

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map('gI', picker.lsp_implementations, '[G]oto [I]mplementation')

      map('gl', vim.diagnostic.open_float, 'Show diagnostic')

      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      map('gK', picker.lsp_type_definitions, 'Type [D]efinition')

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map('gs', picker.lsp_symbols, '[D]ocument [S]ymbols')

      -- Fuzzy find all the symbols in your current workspace.
      --  Similar to document symbols, except searches over your entire project.
      map('gS', function()
        picker.lsp_symbols({ workspace = true })
      end, '[W]orkspace [S]ymbols')

      local is_virtual_text_enabled = true
      map('<leader>D', function()
        is_virtual_text_enabled = not is_virtual_text_enabled

        vim.diagnostic.config({
          virtual_text = is_virtual_text_enabled and virtual_text_settings or false,
        })
      end, 'Enable Virtual Text')

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  vim.diagnostic.config({
    update_in_insert = false,

    virtual_text = virtual_text_settings,
  })

  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}))

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
  vim.list_extend(ensure_installed, {
    'stylua', -- Used to format Lua code
  })

  require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

  require('mason-lspconfig').setup({})
  require('mason-lspconfig').setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      local server = servers[server_name] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for ts_ls)
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

      -- if utils.is_dotfiles() then
      --   return
      -- end

      require('lspconfig')[server_name].setup(vim.tbl_extend('keep', {
        on_attach = function(client, bufnr)
          if server.on_attach then
            server.on_attach(client, bufnr)
          end

          client.server_capabilities.semanticTokensProvider = nil
        end,
      }, server))
    end,
  })

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
      {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
          -- 'rafamadriz/friendly-snippets',
        },

        -- use a release tag to download pre-built binaries
        version = '*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts_extend = { 'sources.default' },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
          -- sources = {
          --   default = { 'lsp', 'path', 'snippets', 'buffer' },
          --
          --   providers = {
          --     path = {
          --       -- @see https://github.com/Saghen/blink.cmp/discussions/884
          --       enabled = function()
          --         return not vim.tbl_contains(
          --           { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
          --           vim.bo.filetype
          --         )
          --       end,
          --     },
          --
          --     lsp = {
          --       fallbacks = { 'buffer', 'path' },
          --     },
          --   },
          -- },

          sources = {
            providers = {
              cmdline = {
                min_keyword_length = function(ctx)
                  -- when typing a command, only show when the keyword is 3 characters or longer
                  if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
                    return 3
                  end
                  return 0
                end,
              },
            },
          },

          signature = { enabled = true },

          completion = {
            ghost_text = { enabled = true },

            keyword = {
              range = 'full',
            },

            accept = {
              auto_brackets = {
                enabled = false,
              },
            },

            -- menu = {
            --   cmdline_position = function()
            --     if vim.g.ui_cmdline_pos ~= nil then
            --       local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            --       return { pos[1] - 1, pos[2] }
            --     end
            --     local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            --     return { vim.o.lines - height, 0 }
            --   end,
            -- },
          },

          keymap = {
            preset = 'super-tab',

            ['<CR>'] = { 'select_and_accept', 'fallback' },

            -- cmdline = {
            --   preset = 'super-tab',
            -- },
          },

          cmdline = {
            completion = {
              menu = { auto_show = true },
              ghost_text = { enabled = true },
            },
            keymap = {
              preset = 'super-tab',

              ['<CR>'] = { 'select_accept_and_enter', 'fallback' },
            },
          },
        },
      },

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
