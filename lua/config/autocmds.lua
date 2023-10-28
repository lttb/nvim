-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local utils = require('lttb.utils')

-- vim.cmd('Neotree show')

-- vim.api.nvim_create_autocmd({ 'VimEnter' }, {
-- 	-- it should be "nested" not to show the number column
-- 	-- @see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1106
-- 	nested = true,
-- 	callback = function(data)
-- 		if not utils.should_open_sidebar(data) then
-- 			return
-- 		end
--
-- 		-- open the tree but don't focus it
-- 		vim.cmd('Neotree show')
-- 	end,
-- })

vim.api.nvim_create_autocmd('ColorScheme', {
	callback = function()
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

		-- local splitLineHL = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
		--
		-- vim.api.nvim_set_hl(0, 'IlluminatedWordText', {
		-- 	bg = splitLineHL.bg,
		-- 	fg = splitLineHL.bg,
		-- 	underline = false,
		-- 	default = false,
		-- })

		local splitLineHL = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
		vim.api.nvim_set_hl(0, 'VertSplit', {
			bg = splitLineHL.bg,
			fg = splitLineHL.bg,
			default = false,
		})
		vim.api.nvim_set_hl(0, 'WinSeparator', {
			bg = splitLineHL.bg,
			fg = splitLineHL.bg,
			default = false,
		})

		-- local statusLineHL = vim.api.nvim_get_hl(0, {name = 'StatusLine'})
		-- vim.api.nvim_set_hl(0, 'StatusLine', {
		--   bg = splitLineHL.background,
		--   fg = statusLineHL.foreground,
		--   default = false,
		-- })
		-- vim.api.nvim_set_hl(0, 'StatusLineNC', {
		-- 	bg = splitLineHL.bg,
		-- 	fg = statusLineHL.bg,
		-- 	default = false,
		-- })

		local lush = require('lush')
		local hsluv = lush.hsluv

		local normalHL = vim.api.nvim_get_hl(0, { name = 'Normal' })

		local function number_to_hex(color)
			if color == nil then
				return '#' .. string.format('%06x', 0)
			end
			return '#' .. string.format('%06x', color)
		end

		local function alpha(color, a)
			return hsluv(number_to_hex(normalHL.bg)).mix(hsluv(number_to_hex(color)), 100 * (1 - a)).hex
		end
		--
		local function extend_alpha_bg(hl, hl_extend, color_name, a)
			local hlExtendHL = vim.api.nvim_get_hl(0, { name = hl_extend })
			local currentHL = vim.api.nvim_get_hl(0, { name = hl })
			vim.api.nvim_set_hl(0, hl, {
				bg = alpha(hlExtendHL[color_name], a),
				fg = currentHL.fg,
				underline = false,
				default = false,
			})
		end
		--
		extend_alpha_bg('DiagnosticUnderlineError', 'DiagnosticError', 'foreground', 0.1)
		extend_alpha_bg('DiagnosticUnderlineWarn', 'DiagnosticWarn', 'foreground', 0.1)
		extend_alpha_bg('DiagnosticUnderlineInfo', 'DiagnosticInfo', 'foreground', 0.1)
		extend_alpha_bg('DiagnosticUnderlineHint', 'DiagnosticHint', 'foreground', 0.1)
		--
		-- extend_alpha_bg('Visual', 'background', 'MiniCursorword', 0.8)
		extend_alpha_bg('IlluminatedWordText', 'Visual', 'background', 0.8)
		extend_alpha_bg('IlluminatedWordRead', 'Visual', 'background', 0.8)
		extend_alpha_bg('IlluminatedWordWrite', 'Visual', 'background', 0.8)
		--
		-- fix gitsigns virtual text colour
		vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', {
			fg = alpha(normalHL.fg, 0.4),
			underline = false,
			default = false,
		})
	end,
})

-- @see https://www.reddit.com/r/neovim/comments/152bs5t/comment/jsdrz6e/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_exec_autocmds('ColorScheme', {})
-- vim.api.nvim_exec_autocmds('VimEnter', {})

require('lazyvim.util').lsp.on_attach(function(_, buffer)
	-- create the autocmd to show diagnostics
	vim.api.nvim_create_autocmd('CursorHold', {
		group = utils.augroup('diagnostics_hover'),
		buffer = buffer,
		callback = function()
			local opts = {
				focusable = false,
				close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
				border = 'rounded',
				source = 'always',
				prefix = ' ',
				scope = 'cursor',
			}
			vim.diagnostic.open_float(nil, opts)
		end,
	})
end)
