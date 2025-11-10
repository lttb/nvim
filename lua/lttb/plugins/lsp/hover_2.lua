local function lttb_k()
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

  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = lnum })
  local diag_win

  vim.schedule(function()
    -- 1) open diagnostics first if any
    if #diags > 0 then
      local _, w = vim.diagnostic.open_float(nil, {
        border = border,
        focusable = false,
        max_width = math.min(80, math.floor(vim.o.columns * 0.6)),
        focus_id = 'lttb-diagnostic-float',
      })
      diag_win = w
    end

    -- 2) schedule hover using a positioned handler (don’t override buf.hover)
    vim.schedule(function()
      local rel, row, col = 'cursor', 1, 0
      if diag_win and vim.api.nvim_win_is_valid(diag_win) then
        local cfg = vim.api.nvim_win_get_config(diag_win)
        local h = vim.api.nvim_win_get_height(diag_win)
        rel = cfg.relative or 'cursor'
        row = (cfg.row or 0) + h + 1
        col = cfg.col or 0
      end

      local positioned_hover = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
        focusable = false,
        max_width = math.min(80, math.floor(vim.o.columns * 0.6)),
        relative = rel,
        row = row,
        col = col,
        focus_id = 'lttb-hover-below',
      })

      local params = vim.lsp.util.make_position_params(0, 'utf-16')
      vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result, ctx, _)
        if err or not result then
          return
        end
        positioned_hover(err, result, ctx, nil)
      end)
    end)
  end)
end
