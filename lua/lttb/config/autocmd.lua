local utils = require('lttb.utils')

if utils.is_vscode() then
  return
end

-- Create an autocommand group to organize your autocommands
local lttb_ag = vim.api.nvim_create_augroup('MyAutoCmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = lttb_ag,
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'o' })
    vim.opt_local.formatoptions:append({ 'r', 'n' })
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = lttb_ag,
  callback = function()
    local color = require('lttb.utils.color')

    -- vim.cmd([[
    --   highlight ErrorText gui=NONE
    --   highlight WarningText gui=NONE
    --   highlight InfoText gui=NONE
    --   highlight HintText gui=NONE
    -- ]])

    -- vim.cmd([[
    --   highlight! link NoiceCursor Cursor
    -- ]])

    -- vim.cmd([[
    --   hi NonText guifg=bg
    -- ]])

    -- vim.cmd([[
    --   hi NeoTreeFileNameOpened gui=bold
    -- ]])

    local normalHL = vim.api.nvim_get_hl(0, { name = 'Normal' })
    local splitLineHL = vim.api.nvim_get_hl(0, { name = 'CursorLine' })

    color.extend_hl('VertSplit', {
      bg = splitLineHL.bg,
      fg = splitLineHL.bg,
    })

    color.extend_hl('WinSeparator', {
      bg = splitLineHL.bg,
      fg = splitLineHL.bg,
      -- nvim 0.10 links WinSeparator to Normal
      link = 'WinSeparator',
    })

    color.extend_hl('StatusLine', {
      bg = normalHL.bg,
    })

    color.extend_hl('MiniMapNormal', {
      bg = normalHL.bg,
    })

    color.extend_hl('MiniCursorword', {
      bg = color.alpha_hl('DiagnosticInfo', 'fg', 0.2),
      underline = false,
      default = false,
    })
    color.extend_hl('MiniCursorwordCurrent', {
      bg = color.alpha_hl('DiagnosticInfo', 'fg', 0.2),
      underline = false,
      default = false,
    })

    color.extend_hl('DiagnosticUnderlineWarn', {
      underline = true,
      undercurl = false,
      sp = 'NONE',
    })

    color.extend_hl('DiagnosticUnderlineError', {
      underline = true,
      undercurl = false,
    })

    color.extend_hl('DiagnosticUnderlineInfo', {
      sp = color.alpha_hl('DiagnosticInfo', 'fg', 0.5),
      undercurl = true,
    })

    color.extend_hl('GitSignsCurrentLineBlame', {
      fg = color.alpha(normalHL.fg, 0.25),
    })

    color.extend_hl('IblIndent', {
      fg = color.alpha(normalHL.fg, utils.is_neovide() and 0.025 or 0.1),
      link = 'IblIndent',
    })
    color.extend_hl('IblScope', {
      fg = color.alpha(normalHL.fg, utils.is_neovide() and 0.1 or 0.25),
      link = 'IblScope',
    })

    color.extend_hl('FloatBorder', {
      -- bg = normalHL.bg,
      bg = 'NONE',
    })
    color.extend_hl('NormalFloat', {
      bg = normalHL.bg,
    })
    -- color.extend_hl('HoverBorder', {
    --   bg = 'NONE',
    --   default = 'false',
    --   -- link = 'HoverNormal',
    -- })
    color.extend_hl('TelescopeBorder', {
      bg = normalHL.bg,
    })
    color.extend_hl('TelescopeNormal', {
      bg = normalHL.bg,
    })
    color.extend_hl('TelescopePromptNormal', {
      bg = normalHL.bg,
    })

    if vim.g.colors_name == 'rasmus' then
      -- color.extend_hl('Normal', {
      --   bg = '#24282e',
      -- })
    end
  end,
})

-- Define the autocommand to run vim.diagnostic.reset() on entering normal mode
-- TODO: figure out why diagnostic stuck
-- vim.api.nvim_create_autocmd('ModeChanged', {
--   group = 'MyAutoCmds',
--   pattern = '*:n', -- This pattern matches when entering normal mode
--   callback = function()
--     vim.diagnostic.reset()
--   end,
-- })

if false and utils.is_kitty() then
  vim.api.nvim_create_autocmd('VimLeave', {
    group = lttb_ag,
    callback = function()
      vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-window-title')
    end,
  })

  local function should_update_title(bufnr)
    local buftype = vim.bo[bufnr].buftype
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match('^oil://') then
      return false
    end

    if bufname:find('^term://') ~= nil then
      return false
    end

    if bufname:match('/scratch/') then
      return false
    end

    -- Regular file buffers have an empty buftype and a non-empty bufname
    return buftype == '' and bufname ~= ''
  end

  --- @type uv_handle_t
  local timer = nil

  vim.api.nvim_create_autocmd('BufEnter', {
    group = lttb_ag,
    callback = function()
      if not should_update_title(0) then
        return
      end

      if timer ~= nil and not timer:is_closing() then
        timer:close()
      end

      -- defer title setting to avoid flickering
      timer = vim.defer_fn(function()
        local filepath = vim.fn.expand('%:~:.')

        vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-window-title --temporary ' .. filepath)
      end, 10)
    end,
  })
end
