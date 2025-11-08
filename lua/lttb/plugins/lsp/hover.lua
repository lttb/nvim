local lttb_utils = require('lttb.utils')

local M = {}

-- based on antonk52's hover implementation
-- @see https://github.com/antonk52/dot-files/commit/955b4823f6b1d9ef26498298d4be970cd147fcbb

function M.lsp_hover()
  local util = require('vim.lsp.util')
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1] - 1
  local cursor_col = cursor[2]

  local function is_diagnostic_at_cursor(diagnostic)
    local start_line = diagnostic.lnum or 0
    local end_line = diagnostic.end_lnum or start_line
    if cursor_line < start_line or cursor_line > end_line then
      return false
    end
    local start_col = diagnostic.col or 0
    local end_col = diagnostic.end_col
    if start_line == end_line then
      if end_col then
        return cursor_col >= start_col and cursor_col < end_col
      else
        return cursor_col >= start_col
      end
    end
    if cursor_line == start_line then
      return cursor_col >= start_col
    end
    if cursor_line == end_line then
      if not end_col then
        return true
      end
      return cursor_col < end_col
    end
    return true
  end

  local function collect_diagnostics()
    local lines = {}
    for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
      if diagnostic.message and is_diagnostic_at_cursor(diagnostic) then
        local source = diagnostic.source or 'diagnostic'
        local message = diagnostic.message:gsub('\n', ' ')
        local severity = vim.diagnostic.severity[diagnostic.severity] or 'UNKNOWN SEVERITY'
        lines[#lines + 1] = string.format('**%s %s** %s', severity, source, message)
      end
    end
    return lines
  end

  local win = vim.api.nvim_get_current_win()
  vim.lsp.buf_request_all(0, 'textDocument/hover', function(client)
    return util.make_position_params(win, client.offset_encoding)
  end, function(results, ctx)
    if not ctx or ctx.bufnr ~= bufnr then
      return
    end

    local hover_lines = {}
    for _client_id, resp in pairs(results or {}) do
      if resp.err then
        vim.lsp.log.error(resp.err.code, resp.err.message)
      else
        local result = resp.result
        if result and result.contents then
          local converted = util.convert_input_to_markdown_lines(result.contents)
          converted = vim.split(table.concat(converted or {}, '\n'), '\n', { plain = true, trimempty = true })
          if #converted > 0 then
            vim.list_extend(hover_lines, converted)
          end
        end
      end
    end

    local contents = collect_diagnostics()
    if #hover_lines > 0 then
      if #contents > 0 then
        contents[#contents + 1] = '---'
      end
      vim.list_extend(contents, hover_lines)
    end

    if #contents == 0 then
      return vim.notify('No information available', vim.log.levels.INFO)
    end

    vim.api.nvim_set_hl(0, 'LspFloatBorder', { link = 'IblIndent' })
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

    util.open_floating_preview(lttb_utils.pad_lines(contents, 1, 1, 1, 1), 'markdown', {
      focus_id = 'ak_hover',
      border = border,
    })
  end)
end

return M
