-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

local function config()
  local servers = {
    'sumneko_lua',
    'tsserver',
    'cssls',
    'eslint',
    'graphql',
    'html',
    'jsonls',
    'prismals',
  }

  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = servers,

    automatic_installation = true,
  })

  -- LSP settings.
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
    -- utils.keyplug('lttb-lsp-code-action', vim.lsp.buf.code_action)
    utils.keyplug('lttb-lsp-code-action', '<cmd>CodeActionMenu<cr>')

    utils.keyplug('lttb-lsp-rename', vim.lsp.buf.rename)

    utils.keyplug('lttb-lsp-definition', vim.lsp.buf.definition)

    utils.keyplug('lttb-lsp-implementation', vim.lsp.buf.implementation)

    -- use hover.nvim instead
    utils.keyplug('lttb-lsp-hover-native', vim.lsp.buf.hover)

    utils.keyplug('lttb-lsp-signature-help', vim.lsp.buf.signature_help)

    -- Lesser used LSP functionality

    utils.keyplug('lttb-lsp-declaration', vim.lsp.buf.declaration)

    utils.keyplug('lttb-lsp-type-definition', vim.lsp.buf.type_definition)

    utils.keyplug(
      'lttb-lsp-add-workspace-folder',
      vim.lsp.buf.add_workspace_folder
    )

    utils.keyplug(
      'lttb-lsp-remove-workspace-folder',
      vim.lsp.buf.remove_workspace_folder
    )

    utils.keyplug('lttb-lsp-list-workspace-folders', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)

    -- Disable formatting from the language server to select null-ts by default
    _.server_capabilities.document_formatting = false

    -- Show diagnostics on hover
    -- @see https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-line-diagnostics-automatically-in-hover-window
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = {
            'BufLeave',
            'CursorMoved',
            'InsertEnter',
            'FocusLost',
          },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
      end,
    })
  end

  -- CMP {{{
  local cmp = require('cmp')
  local lspkind = require('lspkind')
  local luasnip = require('luasnip')
  local cmp_buffer = require('cmp_buffer')
  local compare = cmp.config.compare

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete({}),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
      -- { name = 'copilot', group_index = 2 },
      {
        name = 'nvim_lsp',
        keyword_length = 1,
        entry_filter = function(entry)
          -- from cmp docs :h cmp-config.sources[n].entry_filter
          return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
            ~= 'Text'
        end,
      },
      {
        name = 'luasnip',
      },
      {
        name = 'path',
      },
      {
        name = 'buffer',
        keyword_length = 3,
      },
      {
        name = 'rg',
        keyword_length = 3,
      },
    }),

    sorting = {
      comparators = {
        compare.offset,
        compare.score,
        compare.recently_used,
        compare.length,
        compare.locality,
        compare.kind,
        compare.sort_text,
        compare.order,
      },
    },

    formatting = {
      format = function(entry, vim_item)
        vim_item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }

        if vim.tbl_contains({ 'path' }, entry.source.name) then
          local icon, hl_group = require('nvim-web-devicons').get_icon(
            entry:get_completion_item().label
          )
          if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
          end
        end

        return lspkind.cmp_format({ with_text = false })(entry, vim_item)
      end,
    },

    experimental = {
      ghost_text = false, -- this feature conflict with copilot.vim's preview.
    },
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'cmdline' },
      { name = 'path' },
    },
  })

  -- }}}

  vim.diagnostic.config({
    virtual_text = false,
  })

  -- nvim-cmp supports additional completion capabilities
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  capabilities.offsetEncoding = { 'utf-8' }

  for _, lsp in ipairs(servers) do
    require('lspconfig')[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  -- LUA {{{
  -- Make runtime files discoverable to the server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  require('lspconfig').sumneko_lua.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            [vim.fn.stdpath('config')] = true,
          },
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  })
  -- }}}
end

return {
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'saadparwaiz1/cmp_luasnip' },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      'onsails/lspkind.nvim',
      'L3MON4D3/LuaSnip',

      'lukas-reineke/cmp-rg',
    },
    config = config,
  },

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
    config = {
      alpha = 0.5,
      blend_color = '#2a2c3c',
    },
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
  },

  {
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
  },
}
