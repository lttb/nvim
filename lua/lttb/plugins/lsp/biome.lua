local M = {}

-- @see https://github.com/biomejs/biome/discussions/5301#discussioncomment-13831691
---@param bufnr integer
function M.biome_code_action(bufnr)
  local biome_lsp_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'biome' })[1]

  if not biome_lsp_client then
    return
  end

  local start_pos = { line = 0, character = 0 }
  local end_pos = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local end_line = #end_pos

  local range = {
    start = start_pos,
    ['end'] = { line = end_line - 1, character = #end_pos[end_line] },
  }

  local params = {
    textDocument = {
      uri = vim.uri_from_bufnr(bufnr),
    },
    context = {
      diagnostics = {},
      only = {
        -- 'source.organizeImports.biome',
        'source.fixAll.biome',
      },
    },
    range = range,
  }

  local response = biome_lsp_client.request_sync('textDocument/codeAction', params, 5000, bufnr)
  local result, error = response.result, response.error
  if result then
    for _, action in ipairs(result) do
      if
        (action.kind == 'source.organizeImports.biome' or action.kind == 'source.fixAll.biome')
        and action.edit ~= nil
      then
        vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
      end
    end
  else
    vim.notify('Failed to organize imports with Biome:\n\n' .. vim.inspect(error), vim.log.levels.WARN)
  end
end

return M
