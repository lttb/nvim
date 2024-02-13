local utils = require('lttb.utils')

if utils.is_vscode() then
  return {}
end

local js_formatter_fn = function(bufnr)
  local buf_clients = vim.lsp.buf_get_clients()

  local is_biome = false
  for _, lsp in pairs(buf_clients) do
    if lsp.name == 'biome' then
      is_biome = true
      break
    end
  end

  if is_biome and require('conform').get_formatter_info('biome', bufnr).available then
    return { 'biome' }
  elseif require('conform').get_formatter_info('eslint', bufnr).available then
    return { 'prettierd', 'eslint_d' }
  else
    return { 'prettierd' }
  end
end

local js_formatter = js_formatter_fn

local slow_format_filetypes = {}

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = js_formatter,
      typescript = js_formatter,
      typescriptreact = js_formatter,
      json = { js_formatter },
      jsonc = { js_formatter },
      markdown = { js_formatter, 'markdownlint' },
      mdx = { js_formatter, 'markdownlint' },
      py = { 'ruff_fix', 'ruff_format' },

      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace' },
    },

    format_on_save = function(bufnr)
      if slow_format_filetypes[vim.bo[bufnr].filetype] then
        return
      end

      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end

      local function on_format(err)
        if err and err:match('timeout$') then
          slow_format_filetypes[vim.bo[bufnr].filetype] = true
        end
      end

      return { timeout_ms = 200, lsp_fallback = true }, on_format
    end,

    format_after_save = function(bufnr)
      if not slow_format_filetypes[vim.bo[bufnr].filetype] then
        return
      end

      return { lsp_fallback = true }
    end,
  },
}
