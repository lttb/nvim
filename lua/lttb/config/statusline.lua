-- vim:fileencoding=utf-8:foldmethod=marker
-- Native statusline, 1:1 replica of the previous lualine setup.
-- Theme-adaptive: all colors are derived from existing highlight groups on
-- ColorScheme and OptionSet (background), so the bar auto-adjusts to any
-- colorscheme and to dark/light flips without hardcoded hex values.

local M = {}

local DISABLED = {
  NvimTree = true,
  ['neo-tree'] = true,
  oil = true,
}

-- Mirrors lualine/utils/mode.lua mapping so mode labels stay familiar.
local MODE_MAP = {
  ['n']    = { 'NORMAL',    'LttbStlA_N' },
  ['no']   = { 'O-PENDING', 'LttbStlA_N' },
  ['nov']  = { 'O-PENDING', 'LttbStlA_N' },
  ['noV']  = { 'O-PENDING', 'LttbStlA_N' },
  ['niI']  = { 'NORMAL',    'LttbStlA_N' },
  ['niR']  = { 'NORMAL',    'LttbStlA_N' },
  ['niV']  = { 'NORMAL',    'LttbStlA_N' },
  ['nt']   = { 'NORMAL',    'LttbStlA_N' },
  ['ntT']  = { 'NORMAL',    'LttbStlA_N' },
  ['i']    = { 'INSERT',    'LttbStlA_I' },
  ['ic']   = { 'INSERT',    'LttbStlA_I' },
  ['ix']   = { 'INSERT',    'LttbStlA_I' },
  ['v']    = { 'VISUAL',    'LttbStlA_V' },
  ['vs']   = { 'VISUAL',    'LttbStlA_V' },
  ['V']    = { 'V-LINE',    'LttbStlA_V' },
  ['Vs']   = { 'V-LINE',    'LttbStlA_V' },
  ['\22']  = { 'V-BLOCK',   'LttbStlA_V' },
  ['\22s'] = { 'V-BLOCK',   'LttbStlA_V' },
  ['s']    = { 'SELECT',    'LttbStlA_V' },
  ['S']    = { 'S-LINE',    'LttbStlA_V' },
  ['\19']  = { 'S-BLOCK',   'LttbStlA_V' },
  ['R']    = { 'REPLACE',   'LttbStlA_R' },
  ['Rc']   = { 'REPLACE',   'LttbStlA_R' },
  ['Rx']   = { 'REPLACE',   'LttbStlA_R' },
  ['Rv']   = { 'V-REPLACE', 'LttbStlA_R' },
  ['Rvc']  = { 'V-REPLACE', 'LttbStlA_R' },
  ['Rvx']  = { 'V-REPLACE', 'LttbStlA_R' },
  ['c']    = { 'COMMAND',   'LttbStlA_C' },
  ['cv']   = { 'EX',        'LttbStlA_C' },
  ['r']    = { 'PROMPT',    'LttbStlA_N' },
  ['rm']   = { 'MORE',      'LttbStlA_N' },
  ['r?']   = { 'CONFIRM',   'LttbStlA_N' },
  ['!']    = { 'SHELL',     'LttbStlA_N' },
  ['t']    = { 'TERMINAL',  'LttbStlA_N' },
}

function M.mode()
  local m = vim.api.nvim_get_mode().mode
  local entry = MODE_MAP[m] or MODE_MAP[m:sub(1, 1)] or { m:upper(), 'LttbStlA_N' }
  return ('%%#%s# %s %%*'):format(entry[2], entry[1])
end

function M.lsp_progress()
  local progress = vim.lsp.status()
  if progress ~= '' then
    return ' ' .. progress
  end
  if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
    return ''
  end
  return ''
end

function M.branch()
  local head = vim.b.gitsigns_head
  if head and head ~= '' then
    return ' ' .. head
  end
  return ''
end

function M.filename()
  local full = vim.api.nvim_buf_get_name(0)
  if full == '' then
    -- symbols.unnamed = '' from the old lualine config
    return ''
  end

  local parent = vim.fn.fnamemodify(full, ':h:t')
  local name = vim.fn.fnamemodify(full, ':t')

  local out
  if parent == '' or parent == '.' then
    out = name
  else
    out = parent .. '/' .. name
  end

  if vim.bo.modified then
    out = out .. ' ●'
  end
  if vim.bo.readonly or not vim.bo.modifiable then
    out = out .. ' '
  end

  return out
end

function M.diff()
  local d = vim.b.gitsigns_status_dict
  if not d then
    return ''
  end

  local parts = {}
  if (d.added or 0) > 0 then
    parts[#parts + 1] = '%#LttbStlDiffAdd#+' .. d.added .. '%*'
  end
  if (d.changed or 0) > 0 then
    parts[#parts + 1] = '%#LttbStlDiffChange#~' .. d.changed .. '%*'
  end
  if (d.removed or 0) > 0 then
    parts[#parts + 1] = '%#LttbStlDiffDelete#-' .. d.removed .. '%*'
  end

  return table.concat(parts, ' ')
end

local DIAG_ICONS = {
  [vim.diagnostic.severity.ERROR] = { ' ', 'LttbStlDiagErr' },
  [vim.diagnostic.severity.WARN]  = { ' ', 'LttbStlDiagWarn' },
  [vim.diagnostic.severity.INFO]  = { ' ', 'LttbStlDiagInfo' },
  [vim.diagnostic.severity.HINT]  = { ' ', 'LttbStlDiagHint' },
}

function M.diagnostics()
  local c = vim.diagnostic.count(0)
  local SEV = vim.diagnostic.severity

  local parts = {}
  for _, sev in ipairs({ SEV.ERROR, SEV.WARN, SEV.INFO, SEV.HINT }) do
    if (c[sev] or 0) > 0 then
      local icon, hl = DIAG_ICONS[sev][1], DIAG_ICONS[sev][2]
      parts[#parts + 1] = ('%%#%s#%s%d%%*'):format(hl, icon, c[sev])
    end
  end

  return table.concat(parts, ' ')
end

function M.filetype()
  local ft = vim.bo.filetype
  if ft == '' then
    return ''
  end

  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if ok then
    local icon = devicons.get_icon_by_filetype(ft)
    if icon then
      return icon .. ' ' .. ft
    end
  end

  return ft
end

function M.section_y()
  local items = {
    M.branch(),
    M.filename(),
    M.diff(),
    M.diagnostics(),
    M.filetype(),
    '%P',
  }

  local parts = {}
  for _, v in ipairs(items) do
    if v ~= '' then
      parts[#parts + 1] = v
    end
  end

  local sep = ' %#LttbStlSep#|%#LttbStlY# '
  return '%#LttbStlY# ' .. table.concat(parts, sep) .. ' %*'
end

function M.build()
  if DISABLED[vim.bo.filetype] then
    return ''
  end

  return table.concat({
    M.mode(),
    '%#LttbStlB# %*',
    '%#LttbStlC#',
    M.lsp_progress(),
    '%*',
    '%=',
    M.section_y(),
    '%#LttbStlZ# %l:%c %*',
  })
end

local function get_hl(name, attr, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or not hl or not hl[attr] then
    return fallback
  end
  return hl[attr]
end

function M.apply_highlights()
  local bar_bg = get_hl('StatusLine', 'bg', get_hl('Normal', 'bg', 'NONE'))
  local bar_fg = get_hl('StatusLine', 'fg', get_hl('Comment', 'fg', 'NONE'))

  local mode_fgs = {
    LttbStlA_N = bar_fg,
    LttbStlA_I = get_hl('String', 'fg', bar_fg),
    LttbStlA_V = get_hl('Constant', 'fg', get_hl('Type', 'fg', bar_fg)),
    LttbStlA_C = get_hl('DiagnosticWarn', 'fg', get_hl('WarningMsg', 'fg', bar_fg)),
    LttbStlA_R = get_hl('DiagnosticError', 'fg', get_hl('ErrorMsg', 'fg', bar_fg)),
  }

  local function set(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end

  for name, fg in pairs(mode_fgs) do
    set(name, { bg = bar_bg, fg = fg, bold = true })
  end

  set('LttbStlB',   { bg = bar_bg, fg = bar_fg })
  set('LttbStlC',   { bg = bar_bg, fg = bar_fg })
  set('LttbStlY',   { bg = bar_bg, fg = bar_fg })
  set('LttbStlZ',   { bg = bar_bg, fg = bar_fg, bold = true })
  set('LttbStlSep', { bg = bar_bg, fg = bar_fg })

  set('LttbStlDiffAdd',    { bg = bar_bg, link = 'GitSignsAdd' })
  set('LttbStlDiffChange', { bg = bar_bg, link = 'GitSignsChange' })
  set('LttbStlDiffDelete', { bg = bar_bg, link = 'GitSignsDelete' })
  set('LttbStlDiagErr',    { bg = bar_bg, link = 'DiagnosticError' })
  set('LttbStlDiagWarn',   { bg = bar_bg, link = 'DiagnosticWarn' })
  set('LttbStlDiagInfo',   { bg = bar_bg, link = 'DiagnosticInfo' })
  set('LttbStlDiagHint',   { bg = bar_bg, link = 'DiagnosticHint' })
end

function M.setup()
  vim.o.statusline = "%!v:lua.require'lttb.config.statusline'.build()"
  M.apply_highlights()

  local grp = vim.api.nvim_create_augroup('lttb.statusline', { clear = true })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = grp,
    callback = M.apply_highlights,
  })

  vim.api.nvim_create_autocmd('OptionSet', {
    group = grp,
    pattern = 'background',
    callback = M.apply_highlights,
  })

  vim.api.nvim_create_autocmd({ 'LspProgress', 'DiagnosticChanged', 'ModeChanged', 'BufEnter' }, {
    group = grp,
    callback = function()
      vim.cmd.redrawstatus()
    end,
  })
end

return M
