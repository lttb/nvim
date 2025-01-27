function morningstar_dark#load()
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
highlight Normal guifg=#C1C1C1 guibg=#24282E guisp=NONE blend=NONE gui=NONE
highlight! link ModeMsg Normal
highlight! link NvimTreeExecFile Normal
highlight! link WinBarNC Normal
highlight Bold guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link @markup.strong Bold
highlight Boolean guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=italic
highlight BufferVisible guifg=#D1D1D1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleIndex guifg=#D1D1D1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight BufferVisibleSign guifg=#D1D1D1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemAbbr guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemAbbrDeprecated guifg=#6A6A6A guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemAbbrMatch guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight CmpItemAbbrMatchFuzzy guifg=#ABABAB guibg=NONE guisp=NONE blend=NONE gui=bold
highlight CmpItemKind guifg=#8E8E8E guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CmpItemMenu guifg=#848484 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight CocMarkdownLink guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link LspReferenceRead ColorColumn
highlight! link LspReferenceText ColorColumn
highlight! link LspReferenceWrite ColorColumn
highlight Comment guifg=#555A61 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @comment Comment
highlight Conceal guifg=#848484 guibg=NONE guisp=NONE blend=NONE gui=bold,italic
highlight Constant guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=NONE
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
highlight Cursor guifg=#24282E guibg=#CCCCCC guisp=NONE blend=NONE gui=NONE
highlight! link TermCursor Cursor
highlight CursorLine guifg=NONE guibg=#282C34 guisp=NONE blend=NONE gui=NONE
highlight! link CocMenuSel CursorLine
highlight! link ColorColumn CursorLine
highlight! link CursorColumn CursorLine
highlight! link FzfLuaFzfCursorLine CursorLine
highlight! link NeogitDiffContextHighlight CursorLine
highlight! link TelescopeSelection CursorLine
highlight CursorLineNr guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Delimiter guifg=#7A8495 guibg=NONE guisp=NONE blend=NONE gui=NONE
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
highlight DiagnosticHint guifg=#B279A7 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NotifyDEBUGIcon DiagnosticHint
highlight! link NotifyDEBUGTitle DiagnosticHint
highlight! link NotifyTRACEIcon DiagnosticHint
highlight! link NotifyTRACETitle DiagnosticHint
highlight DiagnosticInfo guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NeogitNotificationInfo DiagnosticInfo
highlight! link NotifyINFOIcon DiagnosticInfo
highlight! link NotifyINFOTitle DiagnosticInfo
highlight! link @comment.note DiagnosticInfo
highlight DiagnosticOk guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticSignError guifg=#DE6E7C guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocErrorSign DiagnosticSignError
highlight DiagnosticSignHint guifg=#B279A7 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocHintSign DiagnosticSignHint
highlight DiagnosticSignInfo guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocInfoSign DiagnosticSignInfo
highlight DiagnosticSignOk guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticSignWarn guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocWarningSign DiagnosticSignWarn
highlight DiagnosticUnderlineError guifg=NONE guibg=NONE guisp=#DE6E7C blend=NONE gui=undercurl
highlight! link CocErrorHighlight DiagnosticUnderlineError
highlight DiagnosticUnderlineHint guifg=NONE guibg=NONE guisp=#B279A7 blend=NONE gui=undercurl
highlight! link CocHintHighlight DiagnosticUnderlineHint
highlight DiagnosticUnderlineInfo guifg=NONE guibg=NONE guisp=#6099C0 blend=NONE gui=undercurl
highlight! link CocInfoHighlight DiagnosticUnderlineInfo
highlight DiagnosticUnderlineOk guifg=NONE guibg=NONE guisp=#819B69 blend=NONE gui=undercurl
highlight DiagnosticUnderlineWarn guifg=NONE guibg=NONE guisp=#B77E64 blend=NONE gui=undercurl
highlight! link CocWarningHighlight DiagnosticUnderlineWarn
highlight DiagnosticUnnecessary guifg=#4E535A guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextError guifg=#DE6E7C guibg=#372E2F guisp=NONE blend=NONE gui=NONE
highlight! link CocErrorVirtualText DiagnosticVirtualTextError
highlight DiagnosticVirtualTextHint guifg=#B279A7 guibg=#342F33 guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextInfo guifg=#6099C0 guibg=#2E3133 guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextOk guifg=#819B69 guibg=#2F312E guisp=NONE blend=NONE gui=NONE
highlight DiagnosticVirtualTextWarn guifg=#B77E64 guibg=#342F2E guisp=NONE blend=NONE gui=NONE
highlight! link CocWarningVirtualText DiagnosticVirtualTextWarn
highlight! link NeogitNotificationWarning DiagnosticWarn
highlight! link NotifyWARNIcon DiagnosticWarn
highlight! link NotifyWARNTitle DiagnosticWarn
highlight DiffAdd guifg=NONE guibg=#313D25 guisp=NONE blend=NONE gui=NONE
highlight! link NeogitDiffAddHighlight DiffAdd
highlight! link diffAdded DiffAdd
highlight! link @diff.plus DiffAdd
highlight DiffChange guifg=NONE guibg=#293B49 guisp=NONE blend=NONE gui=NONE
highlight! link diffChanged DiffChange
highlight! link @diff.delta DiffChange
highlight DiffDelete guifg=NONE guibg=#532F33 guisp=NONE blend=NONE gui=NONE
highlight! link NeogitDiffDeleteHighlight DiffDelete
highlight! link diffRemoved DiffDelete
highlight! link @diff.minus DiffDelete
highlight DiffText guifg=#C1C1C1 guibg=#3F586B guisp=NONE blend=NONE gui=NONE
highlight Directory guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Error guifg=#DE6E7C guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticError Error
highlight! link ErrorMsg Error
highlight! link MasonError Error
highlight! link @comment.error Error
highlight FlashBackdrop guifg=#6C727D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FlashLabel guifg=#C1C1C1 guibg=#3C627D guisp=NONE blend=NONE gui=NONE
highlight FloatBorder guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FloatTitle guifg=#C1C1C1 guibg=#343941 guisp=NONE blend=NONE gui=bold
highlight FoldColumn guifg=#626B79 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight Folded guifg=#A2ACBC guibg=#3D434C guisp=NONE blend=NONE gui=NONE
highlight Function guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link TroubleNormal Function
highlight! link TroubleText Function
highlight! link @function Function
highlight FzfLuaBufFlagAlt guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaBufFlagCur guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaBufNr guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaFzfMatch guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight FzfLuaHeaderBind guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaHeaderText guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaLiveSym guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaPathColNr guifg=#939FB1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link FzfLuaPathLineNr FzfLuaPathColNr
highlight FzfLuaTabMarker guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight FzfLuaTabTitle guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight GitSignsAdd guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link GitGutterAdd GitSignsAdd
highlight GitSignsChange guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link GitGutterChange GitSignsChange
highlight GitSignsDelete guifg=#DE6E7C guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link GitGutterDelete GitSignsDelete
highlight HopNextKey guifg=#B279A7 guibg=NONE guisp=NONE blend=NONE gui=bold,underline
highlight HopNextKey1 guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=bold,underline
highlight HopNextKey2 guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight HopUnmatched guifg=#6C727D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight IblIndent guifg=#33373D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link IndentLine IblIndent
highlight IblScope guifg=#4B5059 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link IndentLineCurrent IblScope
highlight Identifier guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @property Identifier
highlight! link @string.special.symbol Identifier
highlight! link @variable Identifier
highlight IncSearch guifg=#24282E guibg=#CBA5C3 guisp=NONE blend=NONE gui=bold
highlight! link CurSearch IncSearch
highlight Italic guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link @markup.italic Italic
highlight! link @markup.italic.markdown Italic
highlight LeapBackdrop guifg=#4E5560 guibg=NONE guisp=NONE blend=NONE gui=nocombine
highlight LeapLabel guifg=#F58CE1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight LeapMatch guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold,underline,nocombine
highlight LineNr guifg=#626B79 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link CocCodeLens LineNr
highlight! link LspCodeLens LineNr
highlight! link NeogitHunkHeader LineNr
highlight! link SignColumn LineNr
highlight LspInlayHint guifg=#6A788D guibg=#2A2E35 guisp=NONE blend=NONE gui=NONE
highlight MasonHeader guifg=#24282E guibg=#B77E64 guisp=NONE blend=NONE gui=bold
highlight MasonHighlight guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MasonHighlightBlock guifg=#24282E guibg=#6099C0 guisp=NONE blend=NONE gui=NONE
highlight MasonHighlightBlockBold guifg=#24282E guibg=#6099C0 guisp=NONE blend=NONE gui=bold
highlight MasonHighlightBlockBoldSecondary guifg=#24282E guibg=#B77E64 guisp=NONE blend=NONE gui=bold
highlight MasonHighlightBlockSecondary guifg=#24282E guibg=#B77E64 guisp=NONE blend=NONE gui=NONE
highlight MasonHighlightSecondary guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MasonMuted guifg=#8E8E8E guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight MasonMutedBlock guifg=#24282E guibg=#8E8E8E guisp=NONE blend=NONE gui=NONE
highlight MasonMutedBlockBold guifg=#24282E guibg=#8E8E8E guisp=NONE blend=NONE gui=bold
highlight MoreMsg guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link Question MoreMsg
highlight NeoTreeDirectoryIcon guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NeoTreeDirectoryName guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NeoTreeFileName guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NeogitHunkHeaderHighlight guifg=#C1C1C1 guibg=#2A2E35 guisp=NONE blend=NONE gui=bold
highlight! link NnnNormalNC NnnNormal
highlight! link NnnVertSplit NnnWinSeparator
highlight NoiceCmdlineIcon guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NoiceCmdlinePopupBorder NoiceCmdlineIcon
highlight! link NoiceCmdlinePopupTitle NoiceCmdlineIcon
highlight! link NoiceConfirmBorder NoiceCmdlineIcon
highlight NoiceCompletionItemKindDefault guifg=#8E8E8E guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight NonText guifg=#59616E guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link EndOfBuffer NonText
highlight! link Whitespace NonText
highlight NormalFloat guifg=NONE guibg=#24282E guisp=NONE blend=NONE gui=NONE
highlight Number guifg=#8E8E8E guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link Float Number
highlight NvimTreeCursorLine guifg=NONE guibg=#282C34 guisp=NONE blend=NONE gui=NONE
highlight! link NvimTreeCursorColumn NvimTreeCursorLine
highlight NvimTreeNormal guifg=NONE guibg=#24282E guisp=NONE blend=NONE gui=NONE
highlight! link NnnNormal NvimTreeNormal
highlight NvimTreeRootFolder guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight NvimTreeSpecialFile guifg=#B279A7 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight NvimTreeSymlink guifg=#6099C0 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link NnnWinSeparator NvimTreeWinSeparator
highlight Pmenu guifg=NONE guibg=#343941 guisp=NONE blend=NONE gui=NONE
highlight PmenuSbar guifg=NONE guibg=#5E6673 guisp=NONE blend=NONE gui=NONE
highlight PmenuSel guifg=NONE guibg=#4A505B guisp=NONE blend=NONE gui=NONE
highlight PmenuThumb guifg=NONE guibg=#818C9E guisp=NONE blend=NONE gui=NONE
highlight! link @attribute PreProc
highlight! link @function.macro PreProc
highlight! link @keyword.directive PreProc
highlight! link @keyword.import PreProc
highlight! link @markup.environment PreProc
highlight RenderMarkdownCode guifg=NONE guibg=#2A2E35 guisp=NONE blend=NONE gui=NONE
highlight Search guifg=#C1C1C1 guibg=#7A5172 guisp=NONE blend=NONE gui=NONE
highlight! link CocSearch Search
highlight! link MatchParen Search
highlight! link QuickFixLine Search
highlight! link Sneak Search
highlight SnacksIndent guifg=#33373D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight SnacksIndentScope guifg=#4B5059 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight SneakLabelMask guifg=#B279A7 guibg=#B279A7 guisp=NONE blend=NONE gui=NONE
highlight Special guifg=#969696 guibg=NONE guisp=NONE blend=NONE gui=bold
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
highlight SpecialComment guifg=#6C727D guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link markdownUrl SpecialComment
highlight! link @markup.link.url.markdown SpecialComment
highlight SpecialKey guifg=#59616E guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link @string.escape.markdown SpecialKey
highlight SpellBad guifg=#CB7A83 guibg=NONE guisp=NONE blend=NONE gui=undercurl
highlight! link CocSelectedText SpellBad
highlight SpellCap guifg=#CB7A83 guibg=NONE guisp=NONE blend=NONE gui=undercurl
highlight! link SpellLocal SpellCap
highlight SpellRare guifg=#CB7A83 guibg=NONE guisp=NONE blend=NONE gui=undercurl
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
highlight StatusLine guifg=#C1C1C1 guibg=#383E46 guisp=NONE blend=NONE gui=NONE
highlight! link TabLine StatusLine
highlight! link WinBar StatusLine
highlight StatusLineNC guifg=#D1D1D1 guibg=#2E333A guisp=NONE blend=NONE gui=NONE
highlight! link TabLineFill StatusLineNC
highlight TabLineSel guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link BufferCurrent TabLineSel
highlight TelescopeBorder guifg=#7A8495 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight TelescopeMatching guifg=#B279A7 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight TelescopeSelectionCaret guifg=#DE6E7C guibg=#2A2E35 guisp=NONE blend=NONE gui=NONE
highlight Title guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight! link FzfLuaTitle Title
highlight! link @markup.heading Title
highlight Todo guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @comment.todo Todo
highlight TreesitterContextSeparator guifg=#282C34 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight Type guifg=#8B8278 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link helpSpecial Type
highlight! link markdownCode Type
highlight! link @keyword.storage Type
highlight! link @markup.raw.markdown Type
highlight! link @type Type
highlight! link @variable.parameter.vimdoc Type
highlight Underlined guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link @markup.underline Underlined
highlight VertSplit guifg=#282C34 guibg=#282C34 guisp=NONE blend=NONE gui=NONE
highlight Visual guifg=NONE guibg=#505050 guisp=NONE blend=NONE gui=NONE
highlight WarningMsg guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link DiagnosticWarn WarningMsg
highlight! link NoiceCmdlineIconSearch WarningMsg
highlight! link NoiceCmdlinePopupBorderSearch WarningMsg
highlight! link gitcommitOverflow WarningMsg
highlight! link @comment.warning WarningMsg
highlight WhichKeySeparator guifg=#626B79 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight WildMenu guifg=#24282E guibg=#B279A7 guisp=NONE blend=NONE gui=NONE
highlight! link SneakLabel WildMenu
highlight WinSeparator guifg=#282C34 guibg=#282C34 guisp=NONE blend=NONE gui=NONE
highlight! link NvimTreeWinSeparator WinSeparator
highlight! link NvimTreeGitNew diffAdded
highlight! link NvimTreeGitDirty diffChanged
highlight diffFile guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight diffIndexLine guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight diffLine guifg=#B279A7 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight diffNewFile guifg=#819B69 guibg=NONE guisp=NONE blend=NONE gui=italic
highlight diffOldFile guifg=#DE6E7C guibg=NONE guisp=NONE blend=NONE gui=italic
highlight! link NvimTreeGitDeleted diffRemoved
highlight helpHyperTextEntry guifg=#939FB1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight helpHyperTextJump guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight lCursor guifg=#24282E guibg=#7F7F7F guisp=NONE blend=NONE gui=NONE
highlight! link TermCursorNC lCursor
highlight markdownLinkText guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link @lsp.type.decorator @attribute
highlight! link @lsp.type.deriveHelper @attribute
highlight @boolean guifg=#7C848F guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.boolean @boolean
highlight! link @comment.documentation @comment
highlight! link @lsp.type.comment @comment
highlight @constant guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.typemod.enumMember.defaultLibrary @constant.builtin
highlight! link @lsp.type.enumMember @constant
highlight! link @lsp.typemod.variable.static @constant
highlight @constructor guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
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
highlight @label guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @label.vimdoc guifg=#939FB1 guibg=NONE guisp=NONE blend=NONE gui=bold
highlight @lsp.type.unresolvedReference guifg=NONE guibg=NONE guisp=#DE6E7C blend=NONE gui=undercurl
highlight @lsp.type.variable guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @markup.link.markdown guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight @markup.link.vimdoc guifg=#A3A3A3 guibg=NONE guisp=NONE blend=NONE gui=underline
highlight! link @lsp.type.formatSpecifier @markup.list
highlight! link @markup.list.checked @markup.list
highlight! link @markup.list.unchecked @markup.list
highlight @markup.quote guifg=#8E8E8E guibg=NONE guisp=NONE blend=NONE gui=NONE
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
highlight @tag guifg=#B77E64 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight @tag.attribute.tsx guifg=NONE guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @tag.builtin.tsx @tag
highlight @type.builtin guifg=#91816C guibg=NONE guisp=NONE blend=NONE gui=NONE
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
highlight @variable.tsx guifg=#C1C1C1 guibg=NONE guisp=NONE blend=NONE gui=NONE
highlight! link @lsp.type.generic @variable
highlight! link @lsp.typemod.variable.injected @variable
highlight! link @variable.member @variable
highlight! link @variable.parameter @variable
endfunction
