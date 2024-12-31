local M = {}

function M.setup()
  local cmp = require('cmp')
  local cmp_format = require('lsp-zero').cmp_format({ details = true })
  local cmp_action = require('lsp-zero').cmp_action()

  cmp.setup({
    formatting = vim.tbl_extend('keep', {
      format = function(entry, vim_item)
        cmp_format.format(entry, vim_item)
        -- Set dup to 0 for all sources to remove duplicates
        vim_item.dup = 0
        return vim_item
      end,
    }, cmp_format),

    sources = cmp.config.sources({
      {
        name = 'nvim_lsp',
        entry_filter = function(entry, ctx)
          return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
        end,
        priority = 1000,
      },
      { name = 'buffer', priority = 500 },
      { name = 'path',   priority = 250 },
    }),

    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.kind,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<Tab>'] = cmp_action.luasnip_next_or_expand(),
      ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    }),

    experimental = {
      ghost_text = true,
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      { { name = 'path' } },
      { { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } } }
    ),
  })
end

return M
