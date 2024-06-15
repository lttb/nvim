-- @see https://github.com/hrsh7th/nvim-cmp/pull/1723
---@diagnostic disable: missing-fields

local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

if true then
  return {}
end

table.unpack = table.unpack or unpack

local function init()
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
    { name = 'path', keyword_length = 3 },
    { name = 'buffer', keyword_length = 2 },
    { name = 'rg', keyword_length = 1, max_item_count = 5 },
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
end

return {
  {
    enabled = false,
    'hrsh7th/nvim-cmp',
    init = init,
    dependencies = {
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
}
