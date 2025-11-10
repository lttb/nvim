local lttb_utils = require('lttb.utils')

local M = {}

-- based on antonk52's hover implementation
-- @see https://github.com/antonk52/dot-files/commit/955b4823f6b1d9ef26498298d4be970cd147fcbb

local function normalize_markdown(input)
  local util = require('vim.lsp.util')

  local converted = util.convert_input_to_markdown_lines(input)
  converted = vim.split(table.concat(converted or {}, '\n'), '\n', { plain = true, trimempty = true })

  return converted
end

-- Measure display width after markdown+conceal

local function open_float(lines, marks)
  local util = require('vim.lsp.util')

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

  lines = normalize_markdown(lines)
  lines = lttb_utils.pad_lines(lines, 1, 1, 1, 1)

  local bufnr, winnr = util.open_floating_preview(lines, 'markdown', {
    focus_id = 'lttb_hover',
    border = border,
    max_width = math.min(80, math.floor(vim.o.columns * 0.6)), -- cap width
  })

  local ns = vim.api.nvim_create_namespace('lttb_diag_float')
  for _, m in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(bufnr, ns, m.lnum, m.col_start, { end_col = m.col_end, hl_group = m.hl })
  end

  vim.wo[winnr].wrap = true
  vim.wo[winnr].linebreak = true
  vim.wo[winnr].breakindent = true
  vim.wo[winnr].conceallevel = 2
  vim.wo[winnr].concealcursor = 'n'

  return bufnr, winnr
end

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
    local marks = {}
    local lnum = 0

    local severity_hl = {
      ERROR = 'DiagnosticError',
      WARN = 'DiagnosticWarn',
      INFO = 'DiagnosticInfo',
      HINT = 'DiagnosticHint',
    }

    for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
      if diagnostic.message and is_diagnostic_at_cursor(diagnostic) then
        local source = diagnostic.source or 'diagnostic'
        local message = diagnostic.message
        local severity = vim.diagnostic.severity[diagnostic.severity] or 'UNKNOWN SEVERITY'

        local header = string.format('%s:%s', source, diagnostic.code)
        table.insert(marks, {
          lnum = lnum,
          col_start = 1,
          col_end = 1 + #header,
          hl = severity_hl[severity] or 'DiagnosticInfo',
        })
        lnum = lnum + 3

        lines[#lines + 1] = header
        lines[#lines + 1] = vim.trim(message)
        lines[#lines + 1] = ' '
      end
    end
    return lines, marks
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
          if #result.contents > 0 then
            hover_lines[#hover_lines + 1] = result.contents
          end
          -- local converted = util.convert_input_to_markdown_lines(result.contents)
          -- converted = vim.split(table.concat(converted or {}, '\n'), '\n', { plain = true, trimempty = true })
          -- if #converted > 0 then
          --   vim.list_extend(hover_lines, converted)
          -- end
        end
      end
    end

    local contents, marks = collect_diagnostics()
    if #hover_lines > 0 then
      if #contents > 0 then
        contents[#contents + 1] = '---'
      end
      vim.list_extend(contents, hover_lines)
    end

    if #contents == 0 then
      return vim.notify('No information available', vim.log.levels.INFO)
    end

    open_float(contents, marks)
  end)
end

return M
