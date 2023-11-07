local utils = require('lttb.utils')

if utils.is_vscode() then
  return
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local color = require('lttb.utils.color')

    -- Highlight line number instead of having icons in sign column
    -- @see https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#highlight-line-number-instead-of-having-icons-in-sign-column
    vim.cmd([[
      sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticError
      sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticWarn
      sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticInfo
      sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticHint
    ]])

    vim.cmd([[
      highlight ErrorText gui=NONE
      highlight WarningText gui=NONE
      highlight InfoText gui=NONE
      highlight HintText gui=NONE
    ]])

    vim.cmd([[
      highlight! link NoiceCursor Cursor
    ]])

    vim.cmd([[
      hi NonText guifg=bg
    ]])

    vim.cmd([[
      hi NeoTreeFileNameOpened gui=bold
    ]])

    local normalHL = vim.api.nvim_get_hl(0, { name = 'Normal' })
    local splitLineHL = vim.api.nvim_get_hl(0, { name = 'CursorLine' })

    color.extend_hl('VertSplit', {
      bg = splitLineHL.bg,
      fg = splitLineHL.bg,
    })

    color.extend_hl('WinSeparator', {
      bg = splitLineHL.bg,
      fg = splitLineHL.bg,
    })

    color.extend_hl('StatusLine', {
      bg = normalHL.bg,
    })

    color.extend_hl('MiniMapNormal', {
      bg = normalHL.bg,
    })

    color.extend_hl('MiniCursorword', {
      bg = color.alpha_hl('DiagnosticInfo', 'fg', 0.2),
    })

    color.extend_hl('DiagnosticUnderlineWarn', {
      underdouble = true,
      sp = 'NONE',
    })

    color.extend_hl('DiagnosticUnderlineError', {
      underdouble = true,
    })

    color.extend_hl('DiagnosticUnderlineInfo', {
      sp = color.alpha_hl('DiagnosticInfo', 'fg', 0.5),
      undercurl = true,
    })

    color.extend_hl('GitSignsCurrentLineBlame', {
      fg = color.alpha(normalHL.fg, 0.25),
    })
  end,
})

if utils.is_kitty() then
  vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-window-title')
    end,
  })
  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
      -- defer title setting to avoid flickering
      vim.defer_fn(function()
        local bufname = vim.fn.bufname()

        if bufname == '' or bufname == nil or bufname:find('^term://') ~= nil then
          return
        end

        local filepath = vim.fn.expand('%:~:.')

        vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-window-title --temporary ' .. filepath)
      end, 100)
    end,
  })
end

-- Gain better performance when moving the cursor around
-- @see https://github.com/utilyre/barbecue.nvim#-recipes
vim.api.nvim_create_autocmd({
  'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
  'BufWinEnter',
  'CursorHold',
  'InsertLeave',

  -- include this if you have set `show_modified` to `true`
  'BufModifiedSet',
}, {
  group = vim.api.nvim_create_augroup('barbecue.updater', {}),
  callback = function()
    require('barbecue.ui').update()
  end,
})
