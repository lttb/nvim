function morningstar_light#load()
let g:terminal_color_0 = '#FFFFFF'
let g:terminal_color_1 = '#A8334C'
let g:terminal_color_2 = '#4F6C31'
let g:terminal_color_3 = '#944927'
let g:terminal_color_4 = '#286486'
let g:terminal_color_5 = '#88507D'
let g:terminal_color_6 = '#7C848F'
let g:terminal_color_7 = '#202429'
let g:terminal_color_8 = '#D4D1D1'
let g:terminal_color_9 = '#94253E'
let g:terminal_color_10 = '#3F5A22'
let g:terminal_color_11 = '#803D1C'
let g:terminal_color_12 = '#1D5573'
let g:terminal_color_13 = '#7B3B70'
let g:terminal_color_14 = '#5E6F82'
let g:terminal_color_15 = '#474E58'
highlight Normal guifg=#202429 guibg=#FFFFFF guisp=NONE blend=NONE gui=NONE
highlight! link ModeMsg Normal
highlight! link NvimTreeExecFile Normal
highlight! link WinBarNC Normal
highlight Bold guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link @markup.strong Bold
highlight Boolean guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=italic
highlight BufferVisible guifg=#525A65 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleIndex guifg=#525A65 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleSign guifg=#525A65 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemAbbr guifg=#3A4048 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemAbbrDeprecated guifg=#6D7885 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemAbbrMatch guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight CmpItemAbbrMatchFuzzy guifg=#32373E guibg=NONE guisp=NONE blend=NONE gui=bold
highlight CmpItemKind guifg=#4D565F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemMenu guifg=#59626D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CocMarkdownLink guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link LspReferenceRead ColorColumn
highlight! link LspReferenceText ColorColumn
highlight! link LspReferenceWrite ColorColumn
highlight Comment guifg=#A7ACB1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @comment Comment
highlight Conceal guifg=#59626D guibg=NONE guisp=NONE blend=NONE gui=bold,italic
highlight Constant guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link Character Constant
highlight! link String Constant
highlight! link TroubleSource Constant
highlight! link WhichKeyValue Constant
highlight! link helpOption Constant
highlight! link @character Constant
highlight! link @constant.builtin Constant
highlight! link @constant.macro Constant
highlight! link @markup.link Constant
highlight! link @markup.link.url Constant
highlight! link @markup.raw Constant
highlight! link @module Constant
highlight! link @string.regexp Constant
highlight! link @variable.builtin Constant
highlight Cursor guifg=#FFFFFF guibg=#202429 guisp=NONE blend=NONE gui=NONE
highlight! link TermCursor Cursor
highlight CursorLine guifg=NONE guibg=#F4F7F9 guisp=NONE blend=NONE gui=NONE
highlight! link CocMenuSel CursorLine
highlight! link ColorColumn CursorLine
highlight! link CursorColumn CursorLine
highlight! link FzfLuaFzfCursorLine CursorLine
highlight! link NeogitDiffContextHighlight CursorLine
highlight! link TelescopeSelection CursorLine
highlight CursorLineNr guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Delimiter guifg=#8B8B8B guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link markdownLinkTextDelimiter Delimiter
highlight! link @constructor.lua Delimiter
highlight! link @punctuation.bracket Delimiter
highlight! link @punctuation.delimiter Delimiter
highlight! link @punctuation.special Delimiter
highlight! link @tag.delimiter Delimiter
highlight DiagnosticDeprecated guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=strikethrough
highlight! link NeogitNotificationError DiagnosticError
highlight! link NotifyERRORIcon DiagnosticError
highlight! link NotifyERRORTitle DiagnosticError
highlight DiagnosticHint guifg=#88507D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NotifyDEBUGIcon DiagnosticHint
highlight! link NotifyDEBUGTitle DiagnosticHint
highlight! link NotifyTRACEIcon DiagnosticHint
highlight! link NotifyTRACETitle DiagnosticHint
highlight DiagnosticInfo guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NeogitNotificationInfo DiagnosticInfo
highlight! link NotifyINFOIcon DiagnosticInfo
highlight! link NotifyINFOTitle DiagnosticInfo
highlight! link @comment.note DiagnosticInfo
highlight DiagnosticOk guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticSignError guifg=#A8334C guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocErrorSign DiagnosticSignError
highlight DiagnosticSignHint guifg=#88507D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocHintSign DiagnosticSignHint
highlight DiagnosticSignInfo guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocInfoSign DiagnosticSignInfo
highlight DiagnosticSignOk guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticSignWarn guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocWarningSign DiagnosticSignWarn
highlight DiagnosticUnderlineError guifg=NONE guibg=NONE guisp=#A8334C blend=NONE gui=undercurl
highlight! link CocErrorHighlight DiagnosticUnderlineError
highlight DiagnosticUnderlineHint guifg=NONE guibg=NONE guisp=#88507D blend=NONE gui=undercurl
highlight! link CocHintHighlight DiagnosticUnderlineHint
highlight DiagnosticUnderlineInfo guifg=NONE guibg=NONE guisp=#286486 blend=NONE gui=undercurl
highlight! link CocInfoHighlight DiagnosticUnderlineInfo
highlight DiagnosticUnderlineOk guifg=NONE guibg=NONE guisp=#4F6C31 blend=NONE gui=undercurl
highlight DiagnosticUnderlineWarn guifg=NONE guibg=NONE guisp=#944927 blend=NONE gui=undercurl
highlight! link CocWarningHighlight DiagnosticUnderlineWarn
highlight DiagnosticUnnecessary guifg=#B3B6BB guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextError guifg=#A8334C guibg=#F8F2F3 guisp=NONE blend=NONE gui=NONE
highlight! link CocErrorVirtualText DiagnosticVirtualTextError
highlight DiagnosticVirtualTextHint guifg=#88507D guibg=#F8F2F7 guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextInfo guifg=#286486 guibg=#F0F4F8 guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextOk guifg=#4F6C31 guibg=#E9F9DD guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextWarn guifg=#944927 guibg=#F8F2F1 guisp=NONE blend=NONE gui=NONE
highlight! link CocWarningVirtualText DiagnosticVirtualTextWarn
highlight! link NeogitNotificationWarning DiagnosticWarn
highlight! link NotifyWARNIcon DiagnosticWarn
highlight! link NotifyWARNTitle DiagnosticWarn
highlight DiffAdd guifg=NONE guibg=#E1F4D5 guisp=NONE blend=NONE gui=NONE
highlight! link NeogitDiffAddHighlight DiffAdd
highlight! link diffAdded DiffAdd
highlight! link @diff.plus DiffAdd
highlight DiffChange guifg=NONE guibg=#EAEEF3 guisp=NONE blend=NONE gui=NONE
highlight! link diffChanged DiffChange
highlight! link @diff.delta DiffChange
highlight DiffDelete guifg=NONE guibg=#F5ECED guisp=NONE blend=NONE gui=NONE
highlight! link NeogitDiffDeleteHighlight DiffDelete
highlight! link diffRemoved DiffDelete
highlight! link @diff.minus DiffDelete
highlight DiffText guifg=#202429 guibg=#BFCEDC guisp=NONE blend=NONE gui=NONE
highlight Directory guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Error guifg=#A8334C guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticError Error
highlight! link ErrorMsg Error
highlight! link MasonError Error
highlight! link @comment.error Error
highlight FlashBackdrop guifg=#969696 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FlashLabel guifg=#202429 guibg=#B3D9F8 guisp=NONE blend=NONE gui=NONE
highlight FloatBorder guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FloatTitle guifg=#202429 guibg=#E8E8E8 guisp=NONE blend=NONE gui=bold
highlight FoldColumn guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Folded guifg=#555555 guibg=#D1D1D1 guisp=NONE blend=NONE gui=NONE
highlight Function guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link TroubleNormal Function
highlight! link TroubleText Function
highlight! link @function Function
highlight FzfLuaBufFlagAlt guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaBufFlagCur guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaBufNr guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaFzfMatch guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight FzfLuaHeaderBind guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaHeaderText guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaLiveSym guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaPathColNr guifg=#79555B guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link FzfLuaPathLineNr FzfLuaPathColNr
highlight FzfLuaTabMarker guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaTabTitle guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsAdd guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link GitGutterAdd GitSignsAdd
highlight GitSignsChange guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link GitGutterChange GitSignsChange
highlight GitSignsDelete guifg=#A8334C guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link GitGutterDelete GitSignsDelete
highlight HopNextKey guifg=#88507D guibg=NONE guisp=NONE blend=NONE gui=bold,underline
highlight HopNextKey1 guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=bold,underline
highlight HopNextKey2 guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight HopUnmatched guifg=#969696 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight IblIndent guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link IndentLine IblIndent
highlight IblScope guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link IndentLineCurrent IblScope
highlight Identifier guifg=#3A4048 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @property Identifier
highlight! link @string.special.symbol Identifier
highlight! link @variable Identifier
highlight IncSearch guifg=#FFFFFF guibg=#C989BC guisp=NONE blend=NONE gui=bold
highlight! link CurSearch IncSearch
highlight Italic guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link @markup.italic Italic
highlight! link @markup.italic.markdown Italic
highlight LeapBackdrop guifg=#C6C6C6 guibg=NONE guisp=NONE blend=NONE gui=nocombine
highlight LeapLabel guifg=#DE33C6 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight LeapMatch guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold,underline,nocombine
highlight LineNr guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocCodeLens LineNr
highlight! link LspCodeLens LineNr
highlight! link NeogitHunkHeader LineNr
highlight! link SignColumn LineNr
highlight LspInlayHint guifg=#A9979A guibg=#F9F9F9 guisp=NONE blend=NONE gui=NONE
highlight MasonHeader guifg=#FFFFFF guibg=#944927 guisp=NONE blend=NONE gui=bold
highlight MasonHighlight guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MasonHighlightBlock guifg=#FFFFFF guibg=#286486 guisp=NONE blend=NONE gui=NONE
highlight MasonHighlightBlockBold guifg=#FFFFFF guibg=#286486 guisp=NONE blend=NONE gui=bold
highlight MasonHighlightBlockBoldSecondary guifg=#FFFFFF guibg=#944927 guisp=NONE blend=NONE gui=bold
highlight MasonHighlightBlockSecondary guifg=#FFFFFF guibg=#944927 guisp=NONE blend=NONE gui=NONE
highlight MasonHighlightSecondary guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MasonMuted guifg=#4D565F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MasonMutedBlock guifg=#FFFFFF guibg=#4D565F guisp=NONE blend=NONE gui=NONE
highlight MasonMutedBlockBold guifg=#FFFFFF guibg=#4D565F guisp=NONE blend=NONE gui=bold
highlight MoreMsg guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link Question MoreMsg
highlight NeoTreeDirectoryIcon guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NeoTreeDirectoryName guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NeoTreeFileName guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NeogitHunkHeaderHighlight guifg=#202429 guibg=#F6F6F6 guisp=NONE blend=NONE gui=bold
highlight! link NnnNormalNC NnnNormal
highlight! link NnnVertSplit NnnWinSeparator
highlight NoiceCmdlineIcon guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NoiceCmdlinePopupBorder NoiceCmdlineIcon
highlight! link NoiceCmdlinePopupTitle NoiceCmdlineIcon
highlight! link NoiceConfirmBorder NoiceCmdlineIcon
highlight NoiceCompletionItemKindDefault guifg=#4D565F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NonText guifg=#B9B9B9 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link EndOfBuffer NonText
highlight! link Whitespace NonText
highlight NormalFloat guifg=NONE guibg=#FFFFFF guisp=NONE blend=NONE gui=NONE
highlight Number guifg=#4D565F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link Float Number
highlight NvimTreeCursorLine guifg=NONE guibg=#F4F7F9 guisp=NONE blend=NONE gui=NONE
highlight! link NvimTreeCursorColumn NvimTreeCursorLine
highlight NvimTreeNormal guifg=NONE guibg=#FFFFFF guisp=NONE blend=NONE gui=NONE
highlight! link NnnNormal NvimTreeNormal
highlight NvimTreeRootFolder guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight NvimTreeSpecialFile guifg=#88507D guibg=NONE guisp=NONE blend=NONE gui=underline
highlight NvimTreeSymlink guifg=#286486 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NnnWinSeparator NvimTreeWinSeparator
highlight Pmenu guifg=NONE guibg=#E2E2E2 guisp=NONE blend=NONE gui=NONE
highlight PmenuSbar guifg=NONE guibg=#B0B0B0 guisp=NONE blend=NONE gui=NONE
highlight PmenuSel guifg=NONE guibg=#C6C6C6 guisp=NONE blend=NONE gui=NONE
highlight PmenuThumb guifg=NONE guibg=#FFFFFF guisp=NONE blend=NONE gui=NONE
highlight! link @attribute PreProc
highlight! link @function.macro PreProc
highlight! link @keyword.directive PreProc
highlight! link @keyword.import PreProc
highlight! link @markup.environment PreProc
highlight RenderMarkdownCode guifg=NONE guibg=#F9F9F9 guisp=NONE blend=NONE gui=NONE
highlight Search guifg=#202429 guibg=#E7CDE1 guisp=NONE blend=NONE gui=NONE
highlight! link CocSearch Search
highlight! link MatchParen Search
highlight! link QuickFixLine Search
highlight! link Sneak Search
highlight SnacksIndent guifg=#EEEEEE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight SnacksIndentScope guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight SneakLabelMask guifg=#88507D guibg=#88507D guisp=NONE blend=NONE gui=NONE
highlight Special guifg=#474E58 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link WhichKeyGroup Special
highlight! link @character.special Special
highlight! link @function.builtin Special
highlight! link @keyword.debug Special
highlight! link @markup.link.label Special
highlight! link @markup.list Special
highlight! link @markup.math Special
highlight! link @punctuation.special.markdown Special
highlight! link @string.escape Special
highlight! link @string.special Special
highlight SpecialComment guifg=#969696 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link markdownUrl SpecialComment
highlight! link @markup.link.url.markdown SpecialComment
highlight SpecialKey guifg=#B9B9B9 guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link @string.escape.markdown SpecialKey
highlight SpellBad guifg=#974352 guibg=NONE guisp=#A8334C blend=NONE gui=undercurl
highlight! link CocSelectedText SpellBad
highlight SpellCap guifg=#974352 guibg=NONE guisp=#C13C58 blend=NONE gui=undercurl
highlight! link SpellLocal SpellCap
highlight SpellRare guifg=#974352 guibg=NONE guisp=#944927 blend=NONE gui=undercurl
highlight Statement guifg=#626B76 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link FzfLuaBufName Statement
highlight! link PreProc Statement
highlight! link WhichKey Statement
highlight! link @keyword.conditional Statement
highlight! link @keyword.coroutine Statement
highlight! link @keyword.exception Statement
highlight! link @keyword.function Statement
highlight! link @keyword.operator Statement
highlight! link @keyword.repeat Statement
highlight! link @keyword.return Statement
highlight! link @lsp.type.keyword Statement
highlight! link @lsp.typemod.keyword.injected Statement
highlight! link @markup.title.markdown Statement
highlight! link @operator Statement
highlight StatusLine guifg=#202429 guibg=#DDDDDD guisp=NONE blend=NONE gui=NONE
highlight! link TabLine StatusLine
highlight! link WinBar StatusLine
highlight StatusLineNC guifg=#525A65 guibg=#EEEEEE guisp=NONE blend=NONE gui=NONE
highlight! link TabLineFill StatusLineNC
highlight TabLineSel guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link BufferCurrent TabLineSel
highlight TelescopeBorder guifg=#777777 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight TelescopeMatching guifg=#88507D guibg=NONE guisp=NONE blend=NONE gui=bold
highlight TelescopeSelectionCaret guifg=#A8334C guibg=#F6F6F6 guisp=NONE blend=NONE gui=NONE
highlight Title guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link FzfLuaTitle Title
highlight! link @markup.heading Title
highlight Todo guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @comment.todo Todo
highlight TreesitterContextSeparator guifg=#F4F7F9 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Type guifg=#7D6D81 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link helpSpecial Type
highlight! link markdownCode Type
highlight! link @keyword.storage Type
highlight! link @markup.raw.markdown Type
highlight! link @type Type
highlight! link @variable.parameter.vimdoc Type
highlight Underlined guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link @markup.underline Underlined
highlight VertSplit guifg=#F4F7F9 guibg=#F4F7F9 guisp=NONE blend=NONE gui=NONE
highlight Visual guifg=NONE guibg=#E5E8ED guisp=NONE blend=NONE gui=NONE
highlight WarningMsg guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticWarn WarningMsg
highlight! link NoiceCmdlineIconSearch WarningMsg
highlight! link NoiceCmdlinePopupBorderSearch WarningMsg
highlight! link gitcommitOverflow WarningMsg
highlight! link @comment.warning WarningMsg
highlight WhichKeySeparator guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight WildMenu guifg=#FFFFFF guibg=#88507D guisp=NONE blend=NONE gui=NONE
highlight! link SneakLabel WildMenu
highlight WinSeparator guifg=#F4F7F9 guibg=#F4F7F9 guisp=NONE blend=NONE gui=NONE
highlight! link NvimTreeWinSeparator WinSeparator
highlight! link NvimTreeGitNew diffAdded
highlight! link NvimTreeGitDirty diffChanged
highlight diffFile guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight diffIndexLine guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight diffLine guifg=#88507D guibg=NONE guisp=NONE blend=NONE gui=bold
highlight diffNewFile guifg=#4F6C31 guibg=NONE guisp=NONE blend=NONE gui=italic
highlight diffOldFile guifg=#A8334C guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link NvimTreeGitDeleted diffRemoved
highlight helpHyperTextEntry guifg=#79555B guibg=NONE guisp=NONE blend=NONE gui=bold
highlight helpHyperTextJump guifg=#3A4048 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight lCursor guifg=#FFFFFF guibg=#434A52 guisp=NONE blend=NONE gui=NONE
highlight! link TermCursorNC lCursor
highlight markdownLinkText guifg=#3A4048 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link @lsp.type.decorator @attribute
highlight! link @lsp.type.deriveHelper @attribute
highlight @boolean guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.boolean @boolean
highlight! link @comment.documentation @comment
highlight! link @lsp.type.comment @comment
highlight @constant guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.typemod.enumMember.defaultLibrary @constant.builtin
highlight! link @lsp.type.enumMember @constant
highlight! link @lsp.typemod.variable.static @constant
highlight @constructor guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.typemod.function.defaultLibrary @function.builtin
highlight! link @lsp.typemod.macro.defaultLibrary @function.builtin
highlight! link @lsp.typemod.method.defaultLibrary @function.builtin
highlight! link @function.call @function
highlight! link @function.method @function
highlight! link @function.method.call @function
highlight! link @lsp.typemod.variable.callable @function
highlight! link @keyword.conditional.ternary @keyword.conditional
highlight! link @lsp.typemod.keyword.async @keyword.coroutine
highlight! link @keyword.directive.define @keyword.directive
highlight! link @lsp.type.lifetime @keyword.storage
highlight @label guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @label.vimdoc guifg=#79555B guibg=NONE guisp=NONE blend=NONE gui=bold
highlight @lsp.type.unresolvedReference guifg=NONE guibg=NONE guisp=#A8334C blend=NONE gui=undercurl
highlight @lsp.type.variable guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @markup.link.markdown guifg=#3A4048 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight @markup.link.vimdoc guifg=#3A4048 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link @lsp.type.formatSpecifier @markup.list
highlight! link @markup.list.checked @markup.list
highlight! link @markup.list.unchecked @markup.list
highlight @markup.quote guifg=#4D565F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @markup.raw.block.vimdoc guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @markup.raw.block @markup.raw
highlight @markup.strikethrough guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=strikethrough
highlight @method guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.namespace @module
highlight! link @module.builtin @module
highlight @none guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @number guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.number @number
highlight! link @number.float @number
highlight! link @lsp.type.operator @operator
highlight! link @lsp.typemod.operator.injected @operator
highlight! link @lsp.type.property @property
highlight! link @tag.attribute @property
highlight @string guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.escapeSequence @string.escape
highlight! link @string.special.path @string.special
highlight! link @string.special.url @string.special
highlight! link @lsp.type.string @string
highlight! link @lsp.typemod.string.injected @string
highlight! link @string.documentation @string
highlight @tag guifg=#944927 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @tag.attribute.tsx guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @tag.builtin.tsx @tag
highlight @type.builtin guifg=#896691 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.builtinType @type.builtin
highlight! link @lsp.typemod.class.defaultLibrary @type.builtin
highlight! link @lsp.typemod.enum.defaultLibrary @type.builtin
highlight! link @lsp.typemod.struct.defaultLibrary @type.builtin
highlight! link @lsp.type.typeAlias @type.definition
highlight! link @lsp.type.enum @type
highlight! link @lsp.type.interface @type
highlight! link @lsp.typemod.type.defaultLibrary @type
highlight! link @lsp.typemod.typeAlias.defaultLibrary @type
highlight! link @type.definition @type
highlight! link @type.qualifier @type
highlight! link @lsp.type.selfKeyword @variable.builtin
highlight! link @lsp.type.selfTypeKeyword @variable.builtin
highlight! link @lsp.typemod.variable.defaultLibrary @variable.builtin
highlight! link @lsp.type.parameter @variable.parameter
highlight @variable.tsx guifg=#202429 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.generic @variable
highlight! link @lsp.typemod.variable.injected @variable
highlight! link @variable.member @variable
highlight! link @variable.parameter @variable
endfunction
