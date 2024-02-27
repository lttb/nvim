local M = {}

local orig_virtual_text_handler = vim.diagnostic.handlers.virtual_text
local orig_underline_handler = vim.diagnostic.handlers.underline

local function is_ignored_code(code)
  return string.find(code, 'prettier') or string.find(code, 'no%-unused%-vars')
end

local function filter_diagnostics(diagnostics)
  local filtered = {}
  for _, d in ipairs(diagnostics) do
    local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code) or ''
    if not is_ignored_code(code) then
      table.insert(filtered, d)
    end
  end
  return filtered
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
  -- Enhance both handlers with the new logic
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
