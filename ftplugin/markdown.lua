-- Soft-wrap niceties
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.showbreak = '↪ '

-- Use EditorConfig's width if present; fallback
if vim.opt_local.textwidth:get() == 0 then
  vim.opt_local.textwidth = 80
end

-- Make gq use Vim's formatter (not LSP/formatter plugins)
vim.opt_local.formatexpr = '' -- <— key fix
vim.opt_local.formatprg = '' -- just in case

-- Wrap while typing (optional)
vim.opt_local.formatoptions = vim.opt_local.formatoptions + 'tcrqnj'

-- Reflow whole buffer on save (optional)
vim.api.nvim_create_autocmd('BufWritePre', {
  buffer = 0,
  callback = function()
    -- Treesitter/LSP won’t interfere now; this respects 'textwidth'
    vim.cmd('silent normal! ggVGgq')
  end,
})
