-- vim:fileencoding=utf-8:foldmethod=marker

-- cSpell:words cssls jsonls lspsaga

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function setup_formatters()
  local biome_lsp = require('lttb.plugins.lsp.biome')

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      if client == nil then
        return
      end

      vim.b[ev.buf]['ls_' .. client.name] = client.id
    end,
  })

  vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      if client == nil then
        return
      end

      vim.b[ev.buf]['ls_' .. client.name] = nil
    end,
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('LSPFormat', { clear = true }),
    callback = function(ev)
      vim.lsp.buf.format({
        filter = function(client)
          if client.name == 'yamlls' then
            return vim.b.ls_prettier_ls == nil
          end

          if client.name == 'prettier_ls' then
            return vim.b.ls_biome == nil
          end

          return true
        end,
        bufnr = ev.buf,
      })

      biome_lsp.biome_code_action(ev.buf)
    end,
  })
end

local function config()
  --- @type vim.diagnostic.Opts.VirtualText
  local virtual_text_settings = {
    enabled = false,
    severity = { min = vim.diagnostic.severity.ERROR },
    source = 'if_many',
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

      vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

      vim.keymap.set({ 'n', 'i', 'x' }, '<D-.>', vim.lsp.buf.code_action, { desc = 'Code Action' })
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

  vim.lsp.enable('prettier_ls')
  vim.lsp.enable('cspell_ls')
  vim.lsp.enable('gh_actions_ls')

  vim.lsp.enable('ts_ls', false)

  setup_formatters()
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
    'mason-org/mason-lspconfig.nvim',
    opts = {},
    init = function()
      config()
    end,

    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {},
      },
      -- 'WhoIsSethDaniel/mason-tool-installer.nvim',

      'neovim/nvim-lspconfig',
      'b0o/schemastore.nvim',

      {
        'smjonas/inc-rename.nvim',
        keys = {
          { '<F2>', ':IncRename ' },
        },
      },

      {
        enabled = false,
        'lukas-reineke/lsp-format.nvim',
      },
    },
  },
}
