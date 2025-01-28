local M = {}

local function is_ignored_code(code)
  return string.find(code, 'prettier')
      or string.find(code, 'no%-unused%-vars')
      -- Could not find a declaration file for module .js
      or string.find(code, '[7016]')
end

local function filter_diagnostics(diagnostics)
  return vim.tbl_filter(function(d)
    local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code) or ''

    return not is_ignored_code(code)
  end, diagnostics)
end

local function enhanced_show_handler(orig_handler)
  return function(namespace, bufnr, diagnostics, opts)
    local filtered = filter_diagnostics(diagnostics)
    -- This check ensures that we are updating the diagnostics display properly,
    -- even if the filtered list is empty. It helps in clearing out diagnostics that
    -- should no longer be shown.
    orig_handler.show(namespace, bufnr, filtered, opts)
  end
end

local function enhanced_hide_handler(orig_handler)
  return function(ns, bufnr)
    orig_handler.hide(ns, bufnr)
  end
end

function M.setup()
  local orig_virtual_text_handler = vim.diagnostic.handlers.virtual_text
  local orig_underline_handler = vim.diagnostic.handlers.underline

  vim.diagnostic.handlers.virtual_text = {
    show = enhanced_show_handler(orig_virtual_text_handler),
    hide = enhanced_hide_handler(orig_virtual_text_handler),
  }

  vim.diagnostic.handlers.underline = {
    show = enhanced_show_handler(orig_underline_handler),
    hide = enhanced_hide_handler(orig_underline_handler),
  }
end

return M
