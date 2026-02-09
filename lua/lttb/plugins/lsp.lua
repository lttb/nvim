-- vim:fileencoding=utf-8:foldmethod=marker

-- cSpell:words cssls jsonls lspsaga

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function mason_ensure_installed(list)
  -- @see https://github.com/mason-org/mason-lspconfig.nvim/issues/113#issuecomment-1471346816
  local registry = require('mason-registry')
  for _, pkg_name in ipairs(list) do
    local ok, pkg = pcall(registry.get_package, pkg_name)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end

local function format_preserve_folds(bufnr, format_fn)
  -- Remember cursor/scroll
  local view = vim.fn.winsaveview()

  -- Only save folds + cursor in the view
  local old_viewopts = vim.opt.viewoptions:get()
  vim.opt.viewoptions = { 'folds', 'cursor' }

  -- Save a temporary view (slot 9, for example)
  vim.cmd('silent! mkview 9')

  -- Run your formatting
  format_fn()

  -- Restore folds + cursor
  vim.cmd('silent! loadview 9')

  -- Restore viewoptions and fine-grained view (topline, leftcol, etc.)
  vim.opt.viewoptions = old_viewopts
  vim.fn.winrestview(view)
end

local function setup_formatters()
  local biome_lsp = require('lttb.plugins.lsp.biome')

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local buf = ev.buf

      if vim.bo[buf].filetype == 'markdown' then
        -- Disable LSP formatter for Markdown (keep gq native)
        vim.bo[buf].formatexpr = ''
      end

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
      format_preserve_folds(ev.buf, function()
        pcall(function()
          vim.api.nvim_exec2('silent! undojoin', { output = false })
        end)

        vim.lsp.buf.format({
          filter = function(client)
            if client.name == 'yamlls' then
              return vim.b.ls_prettier_ls == nil
            end

            if client.name == 'prettier_ls' then
              return vim.b.ls_biome == nil and vim.b.ls_oxfmt == nil
            end

            print('client:after', client.name)

            return true
          end,
          bufnr = ev.buf,
          async = false,
        })

        biome_lsp.biome_code_action(ev.buf)
      end)
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

  local border = {
    { '╭', 'LspFloatBorder' },
    { '╌', 'LspFloatBorder' },
    { '╮', 'LspFloatBorder' },
    { '╎', 'LspFloatBorder' },
    { '╯', 'LspFloatBorder' },
    { '╌', 'LspFloatBorder' },
    { '╰', 'LspFloatBorder' },
    { '╎', 'LspFloatBorder' },
  }

  local hover = vim.lsp.buf.hover
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function()
    return hover({
      border = border,
    })
  end

  local open_float = vim.diagnostic.open_float
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.diagnostic.open_float = function()
    return open_float(nil, {
      border = border,
    })
  end

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

      vim.keymap.set('n', 'gl', function()
        open_float(nil, {
          border = border,
        })
      end, { desc = 'Show diagnostic' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

      -- vim.keymap.set('n', 'K', function()
      --   hover({
      --     border = border,
      --   })
      --
      --   -- require('hover').open()
      --
      --   -- if vim.bo.filetype == 'help' then
      --   --   return 'K'
      --   -- end
      --   --
      --   -- require('lttb.plugins.lsp.hover').lsp_hover()
      -- end, { desc = 'LSP Hover (with diagnostics)', noremap = true, expr = true })

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

  require('mason-lspconfig').setup({
    ensure_installed = {
      'bashls',
      'beautysh',
      'biome',
      'cspell_ls',
      'cssls',
      'eslint',
      'gh_actions_ls',
      'html',
      'jsonls',
      'lua_ls',
      'marksman',
      'oxlint',
      'rust_analyzer',
      'shellcheck',
      'shfmt',
      'stylua',
      'tailwindcss',
      'taplo',
      'tsgo',
      'vtsls',
      'yamlls',
    },
    exclude = {
      'ts_ls',
      'prettier',
    },
  })

  mason_ensure_installed({ 'shfmt', 'beautysh', 'spellcheck' })

  vim.lsp.enable('oxfmt')
  vim.lsp.enable('prettier_ls')
  -- vim.lsp.enable('cspell_ls')
  -- vim.lsp.enable('gh_actions_ls')

  vim.lsp.enable('vtsls', true)
  vim.lsp.enable('tsgo', false)
  vim.lsp.enable('ts_ls', false)
  vim.lsp.enable('prettier', false)

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

    config = config,

    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {},
      },
      -- 'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'neovim/nvim-lspconfig' },

      {
        'b0o/schemastore.nvim',
      },

      {
        'smjonas/inc-rename.nvim',
        opts = {},
        keys = {
          { '<F2>', ':IncRename ' },
        },
      },

      {
        enabled = false,
        'lukas-reineke/lsp-format.nvim',
      },

      {
        'zeioth/garbage-day.nvim',
        event = 'VeryLazy',
        opts = {},
      },

      {
        enabled = false,
        'lewis6991/hover.nvim',
        opts = {
          preview_opts = {
            border = {
              { '╭', 'LspFloatBorder' },
              { '╌', 'LspFloatBorder' },
              { '╮', 'LspFloatBorder' },
              { '╎', 'LspFloatBorder' },
              { '╯', 'LspFloatBorder' },
              { '╌', 'LspFloatBorder' },
              { '╰', 'LspFloatBorder' },
              { '╎', 'LspFloatBorder' },
            },
          },
        },
      },
    },
  },
}
