local utils = require('lttb.utils')
local theme = require('lttb.theme')

if utils.is_vscode() then
  return
end

-- vim.opt.background = theme.variant
-- vim.cmd.colorscheme(theme.colorscheme)

-- add treesitter support for some themes
-- @see https://github.com/projekt0n/github-nvim-theme/issues/220
-- if theme.name == 'github' then
--   require('lttb.utils.treesitter-hl')
-- end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if theme.colorscheme == 'github_light' then
      -- NOTE: for some reason nvim_set_hl didn't override
      -- vim.api.nvim_set_hl(0, 'TreesitterContext', {
      --   link = 'CursorLineFold',
      --   default = false,
      --   nocombine = true,
      -- })
      -- vim.cmd('hi! link TreesitterContext CursorLineFold')
    end

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

    local normalHL = vim.api.nvim_get_hl_by_name('Normal', true)

    local splitLineHL = vim.api.nvim_get_hl_by_name('CursorLine', true)
    vim.api.nvim_set_hl(0, 'VertSplit', {
      bg = splitLineHL.background,
      fg = splitLineHL.background,
      default = false,
    })
    vim.api.nvim_set_hl(0, 'WinSeparator', {
      bg = splitLineHL.background,
      fg = splitLineHL.background,
      default = false,
    })

    local statusLineHL = vim.api.nvim_get_hl_by_name('StatusLine', true)
    vim.api.nvim_set_hl(0, 'StatusLine', {
      bg = normalHL.background,
      default = false,
    })
    -- vim.api.nvim_set_hl(0, 'StatusLineNC', {
    --   bg = normalHL.background,
    --   fg = normalHL.background,
    --   default = false,
    -- })

    -- vim.api.nvim_set_hl(0, 'lualine_a_normal', {
    --   bg = splitLineHL.background,
    --   default = false,
    -- })
    -- vim.api.nvim_set_hl(0, 'lualine_b_normal', {
    --   bg = splitLineHL.background,
    --   default = false,
    -- })
    -- vim.api.nvim_set_hl(0, 'lualine_c_normal', {
    --   bg = normalHL.background,
    --   default = false,
    -- })

    vim.api.nvim_set_hl(0, 'MiniMapNormal', {
      bg = normalHL.background,
      default = false,
    })

    local C = require('github-theme.lib.color')

    local function number_to_hex(color)
      if color == nil then
        return string.format('%06x', 0)
      end
      return string.format('%06x', color)
    end

    local function alpha(color, a)
      return C.from_hex(number_to_hex(normalHL.background)):blend(C.from_hex(number_to_hex(color)), a):to_hex()
    end

    local function extend_alpha_bg(hl_extend, color_name, hl, a)
      local hlExtendHL = vim.api.nvim_get_hl_by_name(hl_extend, true)
      local currentHL = vim.api.nvim_get_hl_by_name(hl, true)
      vim.api.nvim_set_hl(0, hl, {
        bg = alpha(hlExtendHL[color_name], a),
        fg = currentHL.foreground,
        underline = false,
        default = false,
      })
    end

    extend_alpha_bg('DiagnosticError', 'foreground', 'DiagnosticUnderlineError', 0.1)
    extend_alpha_bg('DiagnosticWarn', 'foreground', 'DiagnosticUnderlineWarn', 0.1)
    extend_alpha_bg('DiagnosticInfo', 'foreground', 'DiagnosticUnderlineInfo', 0.1)
    extend_alpha_bg('DiagnosticHint', 'foreground', 'DiagnosticUnderlineHint', 0.1)

    if theme.name == 'kanagawa' then
      extend_alpha_bg('Normal', 'background', 'SignColumn', 1)
      extend_alpha_bg('Normal', 'background', 'LineNr', 1)
    end

    extend_alpha_bg('Visual', 'background', 'MiniCursorword', 0.8)

    -- fix gitsigns virtual text colour
    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', {
      fg = alpha(normalHL.foreground, 0.4),
      underline = false,
      default = false,
    })
  end,
})

if theme.colorscheme == 'edge' then
  if theme.variant == 'dark' then
    vim.api.nvim_set_hl(0, '@variable', { fg = '#fafafa', link = nil, default = false, nocombine = true })
  end
end

-- TODO: Add support for other themes
if utils.is_kitty() then
  if theme.colorscheme == 'github_light' then
    -- vim.cmd([[
    --   augroup kitty_mp
    --       autocmd!
    --       au VimLeave * :silent !kitty @ --to=$KITTY_LISTEN_ON set-colors --reset
    --       au VimEnter * :silent !kitty @ --to=$KITTY_LISTEN_ON set-colors "$HOME/.config/kitty/themes/github-light.conf"
    --   augroup END
    -- ]])
  end

  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      -- vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=0 margin=0')

      if theme.colorscheme == 'zengithub' and theme.variant == 'light' then
        -- vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-colors "$HOME/.config/kitty/nvim-light.conf"')
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
      vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-window-title')
      -- vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding-h=10')
      -- vim.cmd('silent !kitty @ --to=$KITTY_LISTEN_ON set-colors --reset')
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

-- vim.api.nvim_exec_autocmds('ColorScheme', {})
