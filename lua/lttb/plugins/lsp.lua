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

    -- @see https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-line-diagnostics-automatically-in-hover-window
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false,
          wrap = true,
          border = 'rounded',
          close_events = {
            'BufLeave',
            'CursorMoved',
            'InsertEnter',
            'FocusLost',
            'WinNew',
          },
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        })
      end,
    })
  end)

  lsp_zero.setup()

  vim.diagnostic.config({
    virtual_text = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
  })

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

  local has_words_before = function()
    local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local cmp = require('cmp')
  local compare = cmp.config.compare
  local lspkind = require('lspkind')

  cmp.setup({
    mapping = {
      -- `Enter` key to confirm completion
      ['<CR>'] = cmp.mapping.confirm({ select = true }),

      -- Ctrl+Space to trigger completion menu
      ['<C-Space>'] = cmp.mapping.complete(),

      ['<Tab>'] = cmp.mapping(function(fallback)
        -- support copilot
        -- @see https://github.com/zbirenbaum/copilot.lua/issues/91#issuecomment-1345190310
        -- if require('copilot.suggestion').is_visible() then
        --   require('copilot.suggestion').accept()
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
    },

    experimental = {
      ghost_text = true, -- this feature conflict with copilot.vim's preview.
    },

    sources = cmp.config.sources({
      -- { name = 'copilot', group_index = 2 },
      {
        name = 'nvim_lsp',
        keyword_length = 1,
        entry_filter = function(entry)
          -- from cmp docs :h cmp-config.sources[n].entry_filter
          return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
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
        -- keyword_length = 3,
      },
      {
        name = 'rg',
        -- keyword_length = 3,
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
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' },
        },
      },
    }),
  })
end

return {

  {
    'VonHeikemen/lsp-zero.nvim',
    lazy = false,
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

      { 'hinell/lsp-timeout.nvim', dependencies = { 'neovim/nvim-lspconfig' } },
    },
  },
}
