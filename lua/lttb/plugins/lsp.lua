-- vim:fileencoding=utf-8:foldmethod=marker

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
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, {
      buffer = bufnr,
      desc = desc,
    })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap(
    '<leader>ds',
    require('telescope.builtin').lsp_document_symbols,
    '[D]ocument [S]ymbols'
  )
  nmap(
    '<leader>ws',
    require('telescope.builtin').lsp_dynamic_workspace_symbols,
    '[W]orkspace [S]ymbols'
  )

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap(
    '<leader>wa',
    vim.lsp.buf.add_workspace_folder,
    '[W]orkspace [A]dd Folder'
  )
  nmap(
    '<leader>wr',
    vim.lsp.buf.remove_workspace_folder,
    '[W]orkspace [R]emove Folder'
  )
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Disable formatting from the language server to select null-ts by default
  _.server_capabilities.document_formatting = false
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
    {
      name = 'nvim_lsp',
      keyword_length = 1,
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
      compare.locality,
      compare.recently_used,
      compare.score,
      compare.offset,
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
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
-- }}}
