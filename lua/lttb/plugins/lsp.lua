-- vim:fileencoding=utf-8:foldmethod=marker

-- @see https://github.com/hrsh7th/nvim-cmp/pull/1723
---@diagnostic disable: missing-fields

-- cSpell:words cssls jsonls lspsaga

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local function config()
  local lsp_zero = require('lsp-zero')

  lsp_zero.extend_lspconfig()

  require('neoconf').setup({})
  require('typescript-tools').setup({})

  vim.diagnostic.config({
    update_in_insert = false,

    virtual_text = {
      severity = { min = vim.diagnostic.severity.ERROR },
      source = false,
      spacing = 1,
    },
  })

  lsp_zero.configure('lua_ls', {
    settings = {
      Lua = {
        format = {
          enable = true,
          defaultConfig = {
            indent_style = 'space',
            indent_size = '2',
          },
        },
        -- NOTE: it seems a bit slow
        -- diagnostics = { neededFileStatus = { ['codestyle-check'] = 'Any' } },
        completion = { callSnippet = 'Replace' },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
      },
    },
  })

  lsp_zero.on_attach(function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

  lsp_zero.setup()

  local orig_virtual_text_handler = vim.diagnostic.handlers.virtual_text
  local orig_underline_handler = vim.diagnostic.handlers.underline

  local function filter_diagnostics(diagnostics)
    local filtered = {}
    for k, d in pairs(diagnostics) do
      local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code) or ''
      local is_ignored = string.find(code, 'prettier') or string.find(code, 'no%-unused%-vars')

      if not is_ignored then
        filtered[k] = d
      end
    end

    return filtered
  end
  vim.diagnostic.handlers.virtual_text = {
    show = function(namespace, bufnr, diagnostics, opts)
      orig_virtual_text_handler.show(namespace, bufnr, filter_diagnostics(diagnostics), opts)
    end,
    hide = orig_virtual_text_handler.hide,
  }
  vim.diagnostic.handlers.underline = {
    show = function(namespace, bufnr, diagnostics, opts)
      orig_underline_handler.show(namespace, bufnr, filter_diagnostics(diagnostics), opts)
    end,
    hide = orig_underline_handler.hide,
  }

  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = { 'rust_analyzer', 'lua_ls', 'cssls', 'eslint', 'html', 'jsonls' },
    handlers = { lsp_zero.default_setup, tsserver = lsp_zero.noop },
  })

  -- {{{ CMP

  local has_words_before = function()
    local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local cmp = require('cmp')
  local compare = cmp.config.compare
  local lspkind = require('lspkind')
  local luasnip = require('luasnip')
  local defaults = require('cmp.config.default')()

  local ts_utils = require('nvim-treesitter.ts_utils')

  local function is_in_typescript_context()
    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then
      return false
    end

    while current_node do
      local node_type = current_node:type()
      -- Adjust the node types according to the Treesitter grammar
      if
        node_type == 'object'
        or node_type == 'object_type'
        or node_type == 'type_literal'
        or node_type == 'type_annotation'
        or node_type == 'jsx_element'
        or node_type == 'jsx_self_closing_element'
        or node_type == 'jsx_attribute'
        or node_type == 'jsx_expression'
      then
        return true
      end
      current_node = current_node:parent()
    end
    return false
  end

  local source_nvim_lsp = {
    name = 'nvim_lsp',
    keyword_length = 3,
    entry_filter = function(entry, ctx)
      return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
    end,
  }

  local default_sources = {
    -- { name = 'copilot', group_index = 2 },
    source_nvim_lsp,

    { name = 'luasnip' },
    { name = 'path', keyword_length = 3, max_item_count = 3 },
    { name = 'buffer', keyword_length = 2, max_item_count = 3 },
    { name = 'rg', keyword_length = 1, max_item_count = 3 },
  }

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    pattern = { '*.ts', '*.tsx' },
    callback = function()
      if is_in_typescript_context() then
        cmp.setup.buffer({ sources = { vim.tbl_extend('keep', { keyword_length = 0 }, source_nvim_lsp) } })
      else
        cmp.setup.buffer({ sources = default_sources })
      end
    end,
  })

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    enabled = function()
      local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
      if buftype == 'prompt' then
        return false
      end

      -- Set of commands where cmp will be disabled
      local disabled = { IncRename = true }
      -- Get first word of cmdline
      local cmd = vim.fn.getcmdline():match('%S+')
      -- Return true if cmd isn't disabled
      -- else call/return cmp.close(), which returns false
      return not disabled[cmd] or cmp.close()
    end,

    mapping = {
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      -- ['<CR>']      = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --     cmp.abort()
      --     return
      --   end

      --   fallback()
      -- end),
      ['<C-e>'] = cmp.mapping.abort(),
      -- ['<Esc>'] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.abort()
      --   else
      --     fallback()
      --   end
      -- end),

      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),

      ['<Tab>'] = cmp.mapping(function(fallback)
        -- support copilot
        -- @see https://github.com/zbirenbaum/copilot.lua/issues/91#issuecomment-1345190310
        -- if require('copilot.suggestion').is_visible() then
        --   require('copilot.suggestion').accept()
        if cmp.visible() then
          cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's', 'c' }),
    },

    experimental = {
      ghost_text = true, -- this feature conflict with copilot.vim's preview.
    },

    sources = cmp.config.sources(default_sources),

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
        vim_item.dup = 0
        vim_item.abbr = string.gsub(vim_item.abbr, '^%s+', '')

        if vim.tbl_contains({ 'path' }, entry.source.name) then
          local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
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
  cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      { { name = 'path' } },
      { { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } } }
    ),
  })

  -- }}}
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
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'lukas-reineke/cmp-rg',

      'onsails/lspkind.nvim',

      'L3MON4D3/LuaSnip',

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

      { 'hinell/lsp-timeout.nvim', enabled = false, dependencies = { 'neovim/nvim-lspconfig' } },

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
