-- vim:fileencoding=utf-8:foldmethod=marker

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  local lsp_zero = require('lsp-zero')

  -- {{{ LUA
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  lsp_zero.configure('lua_ls', {
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

  lsp_zero.preset('recommended')

  lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })

    -- utils.keyplug('lttb-lsp-code-action', vim.lsp.buf.code_action)
    utils.keyplug('lttb-lsp-code-action', '<cmd>CodeActionMenu<cr>')

    utils.keyplug('lttb-lsp-rename', vim.lsp.buf.rename)

    utils.keyplug('lttb-lsp-definition-native', vim.lsp.buf.definition)
    utils.keyplug('lttb-lsp-type-definition-native', vim.lsp.buf.type_definition)

    utils.keyplug('lttb-lsp-declaration-native', vim.lsp.buf.declaration)

    utils.keyplug('lttb-lsp-implementation-native', vim.lsp.buf.implementation)

    utils.keyplug('lttb-lsp-references-native', vim.lsp.buf.references)

    -- use hover.nvim instead
    utils.keyplug('lttb-lsp-hover-native', vim.lsp.buf.hover)

    utils.keyplug('lttb-lsp-signature-help', vim.lsp.buf.signature_help)

    -- Lesser used LSP functionality

    utils.keyplug('lttb-lsp-add-workspace-folder', vim.lsp.buf.add_workspace_folder)

    utils.keyplug('lttb-lsp-remove-workspace-folder', vim.lsp.buf.remove_workspace_folder)

    utils.keyplug('lttb-lsp-list-workspace-folders', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)
  end)

  lsp_zero.setup()

  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = {
      'tsserver',
      'rust_analyzer',
      'lua_ls',
      'cssls',
      'eslint',
      'html',
      'jsonls',
    },
    handlers = {
      lsp_zero.default_setup,
    },
  })

  local cmp = require('cmp')
  cmp.setup({
    mapping = {
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = true }),

      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),
    },

    experimental = {
      ghost_text = true, -- this feature conflict with copilot.vim's preview.
    },
  })
end

return {

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = config,
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      { 'neovim/nvim-lspconfig' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/nvim-cmp' },

      { 'L3MON4D3/LuaSnip' },
    },
  },
}
