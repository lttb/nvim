function morningstar_light#load()
let g:terminal_color_0 = '#FFFFFF'
let g:terminal_color_1 = '#A8334C'
let g:terminal_color_2 = '#4F6C31'
let g:terminal_color_3 = '#944927'
let g:terminal_color_4 = '#286486'
let g:terminal_color_5 = '#88507D'
let g:terminal_color_6 = '#6F7882'
let g:terminal_color_7 = '#202429'
let g:terminal_color_8 = '#D4D1D1'
let g:terminal_color_9 = '#94253E'
let g:terminal_color_10 = '#3F5A22'
let g:terminal_color_11 = '#803D1C'
let g:terminal_color_12 = '#1D5573'
let g:terminal_color_13 = '#7B3B70'
let g:terminal_color_14 = '#546576'
let g:terminal_color_15 = '#474E58'
highlight Normal guifg=#202429 guibg=#FFFFFF guisp=NONE gui=NONE cterm=NONE
highlight! link ModeMsg Normal
highlight! link WinBarNC Normal
highlight Bold guifg=NONE guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Boolean guifg=#202429 guibg=NONE guisp=NONE gui=italic cterm=italic
highlight BufferVisible guifg=#525A65 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight BufferVisibleIndex guifg=#525A65 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight BufferVisibleSign guifg=#525A65 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight CocMarkdownLink guifg=#6F7882 guibg=NONE guisp=NONE gui=underline cterm=underline
highlight! link LspReferenceRead ColorColumn
highlight! link LspReferenceText ColorColumn
highlight! link LspReferenceWrite ColorColumn
highlight Comment guifg=#A7ACB1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight Conceal guifg=#59626D guibg=NONE guisp=NONE gui=bold,italic cterm=bold,italic
highlight Constant guifg=#4D565F guibg=NONE guisp=NONE gui=italic cterm=italic
highlight! link Character Constant
highlight! link String Constant
highlight! link TroubleSource Constant
highlight! link WhichKeyValue Constant
highlight! link helpOption Constant
highlight Cursor guifg=#FFFFFF guibg=#202429 guisp=NONE gui=NONE cterm=NONE
highlight! link TermCursor Cursor
highlight CursorLine guifg=NONE guibg=#F4F7F9 guisp=NONE gui=NONE cterm=NONE
highlight! link CocMenuSel CursorLine
highlight! link ColorColumn CursorLine
highlight! link CursorColumn CursorLine
highlight CursorLineNr guifg=#202429 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Delimiter guifg=#8B8B8B guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link markdownLinkTextDelimiter Delimiter
highlight DiagnosticDeprecated guifg=NONE guibg=NONE guisp=NONE gui=strikethrough cterm=strikethrough
highlight! link NotifyERRORIcon DiagnosticError
highlight! link NotifyERRORTitle DiagnosticError
highlight DiagnosticHint guifg=#88507D guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link NotifyDEBUGIcon DiagnosticHint
highlight! link NotifyDEBUGTitle DiagnosticHint
highlight! link NotifyTRACEIcon DiagnosticHint
highlight! link NotifyTRACETitle DiagnosticHint
highlight DiagnosticInfo guifg=#286486 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link NotifyINFOIcon DiagnosticInfo
highlight! link NotifyINFOTitle DiagnosticInfo
highlight DiagnosticOk guifg=#4F6C31 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticSignError guifg=#A8334C guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocErrorSign DiagnosticSignError
highlight DiagnosticSignHint guifg=#88507D guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocHintSign DiagnosticSignHint
highlight DiagnosticSignInfo guifg=#286486 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocInfoSign DiagnosticSignInfo
highlight DiagnosticSignOk guifg=#4F6C31 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticSignWarn guifg=#944927 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocWarningSign DiagnosticSignWarn
highlight DiagnosticUnderlineError guifg=NONE guibg=NONE guisp=#A8334C gui=undercurl cterm=undercurl
highlight! link CocErrorHighlight DiagnosticUnderlineError
highlight DiagnosticUnderlineHint guifg=NONE guibg=NONE guisp=#88507D gui=undercurl cterm=undercurl
highlight! link CocHintHighlight DiagnosticUnderlineHint
highlight DiagnosticUnderlineInfo guifg=NONE guibg=NONE guisp=#286486 gui=undercurl cterm=undercurl
highlight! link CocInfoHighlight DiagnosticUnderlineInfo
highlight DiagnosticUnderlineOk guifg=NONE guibg=NONE guisp=#4F6C31 gui=undercurl cterm=undercurl
highlight DiagnosticUnderlineWarn guifg=NONE guibg=NONE guisp=#944927 gui=undercurl cterm=undercurl
highlight! link CocWarningHighlight DiagnosticUnderlineWarn
highlight DiagnosticUnnecessary guifg=#B3B6BB guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextError guifg=#A8334C guibg=#F8F2F3 guisp=NONE gui=NONE cterm=NONE
highlight! link CocErrorVirtualText DiagnosticVirtualTextError
highlight DiagnosticVirtualTextHint guifg=#88507D guibg=#F8F2F7 guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextInfo guifg=#286486 guibg=#F0F4F8 guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextOk guifg=#4F6C31 guibg=#E9F9DD guisp=NONE gui=NONE cterm=NONE
highlight DiagnosticVirtualTextWarn guifg=#944927 guibg=#F8F2F1 guisp=NONE gui=NONE cterm=NONE
highlight! link CocWarningVirtualText DiagnosticVirtualTextWarn
highlight! link NotifyWARNIcon DiagnosticWarn
highlight! link NotifyWARNTitle DiagnosticWarn
highlight DiffAdd guifg=NONE guibg=#E1F4D5 guisp=NONE gui=NONE cterm=NONE
highlight! link diffAdded DiffAdd
highlight DiffChange guifg=NONE guibg=#EAEEF3 guisp=NONE gui=NONE cterm=NONE
highlight! link diffChanged DiffChange
highlight DiffDelete guifg=NONE guibg=#F5ECED guisp=NONE gui=NONE cterm=NONE
highlight! link diffRemoved DiffDelete
highlight DiffText guifg=#202429 guibg=#BFCEDC guisp=NONE gui=NONE cterm=NONE
highlight Directory guifg=NONE guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Error guifg=#A8334C guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link DiagnosticError Error
highlight! link ErrorMsg Error
highlight FlashBackdrop guifg=#969696 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FlashLabel guifg=#202429 guibg=#B3D9F8 guisp=NONE gui=NONE cterm=NONE
highlight FloatBorder guifg=NONE guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FoldColumn guifg=#A3A3A3 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Folded guifg=#555555 guibg=#D1D1D1 guisp=NONE gui=NONE cterm=NONE
highlight Function guifg=#202429 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link TroubleNormal Function
highlight! link TroubleText Function
highlight FzfLuaBufFlagAlt guifg=#286486 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaBufFlagCur guifg=#944927 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaBufNr guifg=#4F6C31 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaHeaderBind guifg=#4F6C31 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaHeaderText guifg=#944927 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaLiveSym guifg=#944927 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaPathColNr guifg=#79555B guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link FzfLuaPathLineNr FzfLuaPathColNr
highlight FzfLuaTabMarker guifg=#4F6C31 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight FzfLuaTabTitle guifg=#6F7882 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight GitSignsAdd guifg=#4F6C31 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link GitGutterAdd GitSignsAdd
highlight GitSignsChange guifg=#286486 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link GitGutterChange GitSignsChange
highlight GitSignsDelete guifg=#A8334C guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link GitGutterDelete GitSignsDelete
highlight IblIndent guifg=#EEEEEE guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link IndentLine IblIndent
highlight IblScope guifg=#C1C1C1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link IndentLineCurrent IblScope
highlight Identifier guifg=#3A4048 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight IncSearch guifg=#FFFFFF guibg=#C989BC guisp=NONE gui=bold cterm=bold
highlight! link CurSearch IncSearch
highlight Italic guifg=NONE guibg=NONE guisp=NONE gui=italic cterm=italic
highlight LineNr guifg=#A3A3A3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link CocCodeLens LineNr
highlight! link LspCodeLens LineNr
highlight! link SignColumn LineNr
highlight LspInlayHint guifg=#A9979A guibg=#F9F9F9 guisp=NONE gui=NONE cterm=NONE
highlight MoreMsg guifg=#4F6C31 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link Question MoreMsg
highlight NeoTreeDirectoryIcon guifg=#6F7882 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight NeoTreeDirectoryName guifg=#6F7882 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight NeoTreeFileName guifg=#6F7882 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link NnnNormalNC NnnNormal
highlight! link NnnVertSplit NnnWinSeparator
highlight NonText guifg=#B9B9B9 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link EndOfBuffer NonText
highlight! link Whitespace NonText
highlight NormalFloat guifg=NONE guibg=#FFFFFF guisp=NONE gui=NONE cterm=NONE
highlight Number guifg=#4D565F guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link Float Number
highlight Pmenu guifg=NONE guibg=#E2E2E2 guisp=NONE gui=NONE cterm=NONE
highlight PmenuSbar guifg=NONE guibg=#B0B0B0 guisp=NONE gui=NONE cterm=NONE
highlight PmenuSel guifg=NONE guibg=#C6C6C6 guisp=NONE gui=NONE cterm=NONE
highlight PmenuThumb guifg=NONE guibg=#FFFFFF guisp=NONE gui=NONE cterm=NONE
highlight RenderMarkdownCode guifg=NONE guibg=#F9F9F9 guisp=NONE gui=NONE cterm=NONE
highlight Search guifg=#202429 guibg=#E7CDE1 guisp=NONE gui=NONE cterm=NONE
highlight! link CocSearch Search
highlight! link MatchParen Search
highlight! link QuickFixLine Search
highlight! link Sneak Search
highlight SnacksIndent guifg=#EEEEEE guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight SnacksIndentScope guifg=#C1C1C1 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight SneakLabelMask guifg=#88507D guibg=#88507D guisp=NONE gui=NONE cterm=NONE
highlight Special guifg=#474E58 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link WhichKeyGroup Special
highlight SpecialComment guifg=#969696 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link markdownUrl SpecialComment
highlight SpecialKey guifg=#B9B9B9 guibg=NONE guisp=NONE gui=italic cterm=italic
highlight SpellBad guifg=#974352 guibg=NONE guisp=#A8334C gui=undercurl cterm=undercurl
highlight! link CocSelectedText SpellBad
highlight SpellCap guifg=#974352 guibg=NONE guisp=#C13C58 gui=undercurl cterm=undercurl
highlight! link SpellLocal SpellCap
highlight SpellRare guifg=#974352 guibg=NONE guisp=#944927 gui=undercurl cterm=undercurl
highlight Statement guifg=#6F7882 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link FzfLuaBufName Statement
highlight! link PreProc Statement
highlight! link WhichKey Statement
highlight StatusLine guifg=#202429 guibg=#DDDDDD guisp=NONE gui=NONE cterm=NONE
highlight! link TabLine StatusLine
highlight! link WinBar StatusLine
highlight StatusLineNC guifg=#525A65 guibg=#EEEEEE guisp=NONE gui=NONE cterm=NONE
highlight! link TabLineFill StatusLineNC
highlight TabLineSel guifg=NONE guibg=NONE guisp=NONE gui=bold cterm=bold
highlight! link BufferCurrent TabLineSel
highlight Title guifg=#202429 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight Todo guifg=NONE guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight TreesitterContextSeparator guifg=#F4F7F9 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight Type guifg=#7D6D81 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link helpSpecial Type
highlight! link markdownCode Type
highlight Underlined guifg=NONE guibg=NONE guisp=NONE gui=underline cterm=underline
highlight VertSplit guifg=#F4F7F9 guibg=#F4F7F9 guisp=NONE gui=NONE cterm=NONE
highlight Visual guifg=NONE guibg=#E5E8ED guisp=NONE gui=NONE cterm=NONE
highlight WarningMsg guifg=#944927 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight! link DiagnosticWarn WarningMsg
highlight! link gitcommitOverflow WarningMsg
highlight WhichKeySeparator guifg=#A3A3A3 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight WildMenu guifg=#FFFFFF guibg=#88507D guisp=NONE gui=NONE cterm=NONE
highlight! link SneakLabel WildMenu
highlight WinSeparator guifg=#F4F7F9 guibg=#F4F7F9 guisp=NONE gui=NONE cterm=NONE
highlight diffFile guifg=#944927 guibg=NONE guisp=NONE gui=bold cterm=bold
highlight diffIndexLine guifg=#944927 guibg=NONE guisp=NONE gui=NONE cterm=NONE
highlight diffLine guifg=#88507D guibg=NONE guisp=NONE gui=bold cterm=bold
highlight diffNewFile guifg=#4F6C31 guibg=NONE guisp=NONE gui=italic cterm=italic
highlight diffOldFile guifg=#A8334C guibg=NONE guisp=NONE gui=italic cterm=italic
highlight helpHyperTextEntry guifg=#79555B guibg=NONE guisp=NONE gui=bold cterm=bold
highlight helpHyperTextJump guifg=#3A4048 guibg=NONE guisp=NONE gui=underline cterm=underline
highlight lCursor guifg=#FFFFFF guibg=#434A52 guisp=NONE gui=NONE cterm=NONE
highlight! link TermCursorNC lCursor
highlight markdownLinkText guifg=#3A4048 guibg=NONE guisp=NONE gui=underline cterm=underline
endfunction
