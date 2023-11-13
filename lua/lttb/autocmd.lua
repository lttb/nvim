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
      underline = false,
      default = false,
    })
    color.extend_hl('MiniCursorwordCurrent', {
      bg = color.alpha_hl('DiagnosticInfo', 'fg', 0.2),
      underline = false,
      default = false,
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

    color.extend_hl('IblIndent', {
      fg = color.alpha(normalHL.fg, 0.1),
      link = 'IblIndent',
    })
    color.extend_hl('IblScope', {
      fg = color.alpha(normalHL.fg, 0.25),
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

if true then
  -- @see https://github.com/VonHeikemen/lsp-zero.nvim/issues/299#issuecomment-1670150930
  local group = vim.api.nvim_create_augroup('diagnostic_cmds', { clear = true })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    pattern = { 'n:i', 'v:s' },
    desc = 'Disable diagnostics while typing',
    callback = function()
      vim.diagnostic.disable(0)
    end,
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function()
      vim.diagnostic.enable(0)
    end,
  })
end

-- TODO: needs to be improved
if true then
  local operator_started = false
  local function reset()
    local color = require('lttb.utils.color')

    operator_started = false

    vim.defer_fn(function()
      color.extend_hl('MiniCursorword', {
        bg = color.alpha_hl('DiagnosticInfo', 'fg', 0.2),
        underline = false,
        default = false,
      })
    end, 500)
  end

  vim.on_key(function(key)
    local ok, current_mode = pcall(vim.fn.mode)
    if not ok then
      return
    end

    if current_mode == 'n' then
      -- reset if coming back from operator pending mode
      if operator_started then
        reset()
        return
      end

      if key == 'y' then
        operator_started = true

        local color = require('lttb.utils.color')

        color.extend_hl('MiniCursorword', {
          bg = 'NONE',
          default = false,
        })
        return
      end
    end
  end)
end
