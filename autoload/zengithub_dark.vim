function zengithub_dark#load()
let g:terminal_color_0 = '#24282E'
let g:terminal_color_1 = '#DE6E7C'
let g:terminal_color_2 = '#819B69'
let g:terminal_color_3 = '#B77E64'
let g:terminal_color_4 = '#6099C0'
let g:terminal_color_5 = '#B279A7'
let g:terminal_color_6 = '#7C848F'
let g:terminal_color_7 = '#C1C1C1'
let g:terminal_color_8 = '#3E4550'
let g:terminal_color_9 = '#E8838F'
let g:terminal_color_10 = '#8BAE68'
let g:terminal_color_11 = '#D68C67'
let g:terminal_color_12 = '#61ABDA'
let g:terminal_color_13 = '#CF86C1'
let g:terminal_color_14 = '#8298B2'
let g:terminal_color_15 = '#939393'
highlight Normal guifg=#C1C1C1 guibg=#24282E guisp=NONE gui=NONE cterm=NONE
highlight! link ModeMsg Normal
highlight Bold guifg=NONE guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Boolean guifg=#C1C1C1 guibg=NONE guisp=NONE gui=italic cterm=italic
highlight BufferVisible guifg=#D1D1D1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight BufferVisibleIndex guifg=#D1D1D1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight BufferVisibleSign guifg=#D1D1D1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight CocMarkdownLink guifg=#7C848F guibg=NONE guisp=NONE gui=underline cterm=underline
highlight ColorColumn guifg=NONE guibg=#6A4839 guisp=NONE gui=NONE cterm=NONE
highlight! link LspReferenceRead ColorColumn
highlight! link LspReferenceText ColorColumn
highlight! link LspReferenceWrite ColorColumn
highlight Comment guifg=#555A61 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight Conceal guifg=#848484 guibg=NONE guisp=NONE gui=bold,italic cterm=bold,italic
highlight Constant guifg=#8E8E8E guibg=NONE guisp=NONE gui=italic cterm=italic
highlight! link Character Constant
highlight! link String Constant
highlight! link TroubleSource Constant
highlight! link WhichKeyValue Constant
highlight! link helpOption Constant
highlight Cursor guifg=#24282E guibg=#CCCCCC guisp=NONE gui=NONE cterm=NONE
highlight! link TermCursor Cursor
highlight CursorLine guifg=NONE guibg=#282C34 guisp=NONE gui=NONE cterm=NONE
highlight! link CocMenuSel CursorLine
highlight! link CursorColumn CursorLine
highlight CursorLineNr guifg=#C1C1C1 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Delimiter guifg=#7A8495 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link markdownLinkTextDelimiter Delimiter
highlight DiagnosticDeprecated guifg=NONE guibg=NONE guisp=NONE gui=strikethrough cterm=strikethrough
highlight! link NotifyERRORIcon DiagnosticError
highlight! link NotifyERRORTitle DiagnosticError
highlight DiagnosticHint guifg=#B279A7 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link NotifyDEBUGIcon DiagnosticHint
highlight! link NotifyDEBUGTitle DiagnosticHint
highlight! link NotifyTRACEIcon DiagnosticHint
highlight! link NotifyTRACETitle DiagnosticHint
highlight DiagnosticInfo guifg=#6099C0 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link NotifyINFOIcon DiagnosticInfo
highlight! link NotifyINFOTitle DiagnosticInfo
highlight DiagnosticOk guifg=#819B69 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticSignError guifg=#DE6E7C guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocErrorSign DiagnosticSignError
highlight DiagnosticSignHint guifg=#B279A7 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocHintSign DiagnosticSignHint
highlight DiagnosticSignInfo guifg=#6099C0 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocInfoSign DiagnosticSignInfo
highlight DiagnosticSignOk guifg=#819B69 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticSignWarn guifg=#B77E64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocWarningSign DiagnosticSignWarn
highlight DiagnosticUnderlineError guifg=NONE guibg=NONE guisp=#DE6E7C gui=undercurl cterm=undercurl
highlight! link CocErrorHighlight DiagnosticUnderlineError
highlight DiagnosticUnderlineHint guifg=NONE guibg=NONE guisp=#B279A7 gui=undercurl cterm=undercurl
highlight! link CocHintHighlight DiagnosticUnderlineHint
highlight DiagnosticUnderlineInfo guifg=NONE guibg=NONE guisp=#6099C0 gui=undercurl cterm=undercurl
highlight! link CocInfoHighlight DiagnosticUnderlineInfo
highlight DiagnosticUnderlineOk guifg=NONE guibg=NONE guisp=#819B69 gui=undercurl cterm=undercurl
highlight DiagnosticUnderlineWarn guifg=NONE guibg=NONE guisp=#B77E64 gui=undercurl cterm=undercurl
highlight! link CocWarningHighlight DiagnosticUnderlineWarn
highlight DiagnosticUnnecessary guifg=#4E535A guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextError guifg=#DE6E7C guibg=#372E2F guisp=NONE gui=NONE cterm=NONE
highlight! link CocErrorVirtualText DiagnosticVirtualTextError
highlight DiagnosticVirtualTextHint guifg=#B279A7 guibg=#342F33 guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextInfo guifg=#6099C0 guibg=#2E3133 guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextOk guifg=#819B69 guibg=#2F312E guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextWarn guifg=#B77E64 guibg=#342F2E guisp=NONE gui=NONE cterm=NONE
highlight! link CocWarningVirtualText DiagnosticVirtualTextWarn
highlight! link NotifyWARNIcon DiagnosticWarn
highlight! link NotifyWARNTitle DiagnosticWarn
highlight DiffAdd guifg=NONE guibg=#313D25 guisp=NONE gui=NONE cterm=NONE
highlight! link diffAdded DiffAdd
highlight DiffChange guifg=NONE guibg=#293B49 guisp=NONE gui=NONE cterm=NONE
highlight! link diffChanged DiffChange
highlight DiffDelete guifg=NONE guibg=#532F33 guisp=NONE gui=NONE cterm=NONE
highlight! link diffRemoved DiffDelete
highlight DiffText guifg=#C1C1C1 guibg=#3F586B guisp=NONE gui=NONE cterm=NONE
highlight Directory guifg=NONE guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Error guifg=#DE6E7C guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link DiagnosticError Error
highlight! link ErrorMsg Error
highlight FlashBackdrop guifg=#6C727D guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FlashLabel guifg=#C1C1C1 guibg=#3C627D guisp=NONE gui=NONE cterm=NONE
highlight FloatBorder guifg=NONE guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FoldColumn guifg=#626B79 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Folded guifg=#A2ACBC guibg=#3D434C guisp=NONE gui=NONE cterm=NONE
highlight Function guifg=#C1C1C1 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link TroubleNormal Function
highlight! link TroubleText Function
highlight FzfLuaBufFlagAlt guifg=#6099C0 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaBufFlagCur guifg=#B77E64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaBufNr guifg=#819B69 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaHeaderBind guifg=#819B69 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaHeaderText guifg=#B77E64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaLiveSym guifg=#B77E64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaPathColNr guifg=#939FB1 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link FzfLuaPathLineNr FzfLuaPathColNr
highlight FzfLuaTabMarker guifg=#819B69 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaTabTitle guifg=#7C848F guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight GitSignsAdd guifg=#819B69 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link GitGutterAdd GitSignsAdd
highlight GitSignsChange guifg=#6099C0 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link GitGutterChange GitSignsChange
highlight GitSignsDelete guifg=#DE6E7C guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link GitGutterDelete GitSignsDelete
highlight IblIndent guifg=#33373D guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link IndentLine IblIndent
highlight IblScope guifg=#4B5059 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link IndentLineCurrent IblScope
highlight Identifier guifg=#A3A3A3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight IncSearch guifg=#24282E guibg=#CBA5C3 guisp=NONE gui=bold cterm=bold
highlight! link CurSearch IncSearch
highlight Italic guifg=NONE guibg=NONE guisp=NONE gui=italic cterm=italic
highlight LineNr guifg=#626B79 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocCodeLens LineNr
highlight! link LspCodeLens LineNr
highlight! link SignColumn LineNr
highlight LspInlayHint guifg=#6A788D guibg=#2A2E35 guisp=NONE gui=NONE cterm=NONE
highlight MoreMsg guifg=#819B69 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link Question MoreMsg
highlight NeoTreeDirectoryIcon guifg=#7C848F guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight NeoTreeDirectoryName guifg=#7C848F guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight NeoTreeFileName guifg=#7C848F guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link NnnNormalNC NnnNormal
highlight! link NnnVertSplit NnnWinSeparator
highlight NonText guifg=#59616E guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link EndOfBuffer NonText
highlight! link Whitespace NonText
highlight NormalFloat guifg=NONE guibg=#24282E guisp=NONE gui=NONE cterm=NONE
highlight Number guifg=#8E8E8E guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link Float Number
highlight Pmenu guifg=NONE guibg=#343941 guisp=NONE gui=NONE cterm=NONE
highlight PmenuSbar guifg=NONE guibg=#5E6673 guisp=NONE gui=NONE cterm=NONE
highlight PmenuSel guifg=NONE guibg=#4A505B guisp=NONE gui=NONE cterm=NONE
highlight PmenuThumb guifg=NONE guibg=#818C9E guisp=NONE gui=NONE cterm=NONE
highlight RenderMarkdownCode guifg=NONE guibg=#2A2E35 guisp=NONE gui=NONE cterm=NONE
highlight Search guifg=#C1C1C1 guibg=#7A5172 guisp=NONE gui=NONE cterm=NONE
highlight! link CocSearch Search
highlight! link MatchParen Search
highlight! link QuickFixLine Search
highlight! link Sneak Search
highlight SnacksIndent guifg=#33373D guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight SnacksIndentScope guifg=#4B5059 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight SneakLabelMask guifg=#B279A7 guibg=#B279A7 guisp=NONE gui=NONE cterm=NONE
highlight Special guifg=#969696 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link WhichKeyGroup Special
highlight SpecialComment guifg=#6C727D guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link markdownUrl SpecialComment
highlight SpecialKey guifg=#59616E guibg=NONE guisp=NONE gui=italic cterm=italic
highlight SpellBad guifg=#CB7A83 guibg=NONE guisp=NONE gui=undercurl cterm=undercurl
highlight! link CocSelectedText SpellBad
highlight SpellCap guifg=#CB7A83 guibg=NONE guisp=NONE gui=undercurl cterm=undercurl
highlight! link SpellLocal SpellCap
highlight SpellRare guifg=#CB7A83 guibg=NONE guisp=NONE gui=undercurl cterm=undercurl
highlight Statement guifg=#7C848F guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link FzfLuaBufName Statement
highlight! link PreProc Statement
highlight! link WhichKey Statement
highlight StatusLine guifg=#C1C1C1 guibg=#383E46 guisp=NONE gui=NONE cterm=NONE
highlight! link TabLine StatusLine
highlight! link WinBar StatusLine
highlight StatusLineNC guifg=#D1D1D1 guibg=#2E333A guisp=NONE gui=NONE cterm=NONE
highlight! link TabLineFill StatusLineNC
highlight! link WinBarNC StatusLineNC
highlight TabLineSel guifg=NONE guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link BufferCurrent TabLineSel
highlight Title guifg=#C1C1C1 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Todo guifg=NONE guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight TreesitterContextSeparator guifg=#282C34 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight Type guifg=#8B8278 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link helpSpecial Type
highlight! link markdownCode Type
highlight Underlined guifg=NONE guibg=NONE guisp=NONE gui=underline cterm=underline
highlight VertSplit guifg=#282C34 guibg=#282C34 guisp=NONE gui=NONE cterm=NONE
highlight Visual guifg=NONE guibg=#505050 guisp=NONE gui=NONE cterm=NONE
highlight WarningMsg guifg=#B77E64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link DiagnosticWarn WarningMsg
highlight! link gitcommitOverflow WarningMsg
highlight WhichKeySeparator guifg=#626B79 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight WildMenu guifg=#24282E guibg=#B279A7 guisp=NONE gui=NONE cterm=NONE
highlight! link SneakLabel WildMenu
highlight WinSeparator guifg=#282C34 guibg=#282C34 guisp=NONE gui=NONE cterm=NONE
highlight diffFile guifg=#B77E64 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight diffIndexLine guifg=#B77E64 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight diffLine guifg=#B279A7 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight diffNewFile guifg=#819B69 guibg=NONE guisp=NONE gui=italic cterm=italic
highlight diffOldFile guifg=#DE6E7C guibg=NONE guisp=NONE gui=italic cterm=italic
highlight helpHyperTextEntry guifg=#939FB1 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight helpHyperTextJump guifg=#A3A3A3 guibg=NONE guisp=NONE gui=underline cterm=underline
highlight lCursor guifg=#24282E guibg=#7F7F7F guisp=NONE gui=NONE cterm=NONE
highlight! link TermCursorNC lCursor
highlight markdownLinkText guifg=#A3A3A3 guibg=NONE guisp=NONE gui=underline cterm=underline
endfunction
