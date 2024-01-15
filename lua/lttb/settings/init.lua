-- vim:fileencoding=utf-8:foldmethod=marker

--stylua: ignore start

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader       = ' '
vim.g.maplocalleader  = ' '

-- full-width status line
vim.o.laststatus      = 3

-- General {{{
-- NOTE: it's breaking vim-rhubarb (:Gbrowse) if set to true
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.opt.hidden        = true                                             -- Allow switching from unsaved buffer
vim.opt.wrap          = false                                            -- Display long lines as just one line
vim.opt.encoding      = 'utf-8'                                          -- Display this encoding
vim.opt.fileencoding  = 'utf-8'                                          -- Use this encoding when writing to file
vim.opt.mouse         = 'a'                                              -- Enable mouse
vim.opt.backup        = false                                            -- Don't store backup
vim.opt.writebackup   = false                                            -- Don't store backup
vim.opt.timeoutlen    = 1000
vim.opt.updatetime    = 200                                              -- Faster CursorHold
vim.opt.switchbuf     = 'usetab'                                         -- Use already opened buffers when switching
vim.opt.modeline      = true                                             -- Allow modeline

vim.opt.undofile      = true                                             -- Enable persistent undo
vim.opt.undodir       = vim.fn.expand('$HOME/.config/nvim/misc/undodir') -- Set directory for persistent undo

vim.opt.shell         = 'zsh'                                            -- Use zsh as shell

-- }}}

-- UI {{{

vim.opt.termguicolors = true    -- Enable gui colors
vim.opt.cursorline    = true    -- Enable highlighting of the current line
vim.opt.number        = true    -- Show line numbers
vim.opt.signcolumn    = 'yes'   -- Always show signcolumn or it would frequently shift
vim.opt.ruler         = true    -- Always show cursor position
vim.opt.splitbelow    = true    -- Horizontal splits will be below
vim.opt.splitright    = true    -- Vertical splits will be to the right
vim.opt.conceallevel  = 0       -- Don't hide (conceal) special symbols (like `` in markdown)
vim.opt.incsearch     = true    -- Show search results while typing
-- TODO: check if needed
vim.opt.colorcolumn   = '+1'    -- Draw colored column one step to the right of desired maximum width
vim.opt.linebreak     = true    -- Wrap long lines at 'breakat' (if 'wrap' is set)
-- TODO: check if needed
vim.opt.shortmess     = 'aoOFc' -- Disable certain messages from |ins-completion-menu|
-- TODO: check if needed
vim.opt.showmode      = false   -- Don't show mode in command line
vim.opt.showcmd       = false

vim.opt.pumheight     = 10

vim.opt.textwidth     = 120
vim.opt.scrolloff     = 80
vim.opt.sidescrolloff = 20

vim.opt.pumblend      = 10
vim.opt.winblend      = 10

vim.opt.fillchars='eob: '

-- Don't show "Scanning..." messages (improves 'mini.completion')
vim.cmd('set shortmess+=C')

-- Ignore swap warnings
vim.cmd('set shortmess+=A')

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't use defer it because it affects start screen appearance
if vim.fn.exists('syntax_on') ~= 1 then
  vim.cmd([[syntax enable]])
end

-- }}}

-- Editing {{{

vim.opt.expandtab   = true -- Convert tabs to spaces

-- "vim-sleuth" should detect it
vim.opt.tabstop     = 2         -- Insert 2 spaces for a tab
vim.opt.shiftwidth  = 0         -- Use this number of spaces for indentation

vim.opt.smarttab    = true      -- Make tabbing smarter (will realize you have 2 vs 4)
vim.opt.smartindent = true      -- Make indenting smart
vim.opt.autoindent  = true      -- Use auto indent
vim.opt.iskeyword:append('-')   -- Treat dash separated words as a word text object
vim.opt.virtualedit = 'onemore' -- Allow going past the end of line in visual block mode
vim.opt.startofline = false     -- Don't position cursor on line start after certain operations
vim.opt.breakindent = true      -- Indent wrapped lines to match line start

vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = false

vim.opt.wildignorecase = true
vim.opt.wildignore =
'.git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**'

-- TODO: check if that's fine
vim.opt.completeopt = { 'menu', 'noinsert', 'noselect' } -- Customize completions

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gq`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

vim.opt.whichwrap = 'b,s,<,>,[,],h,l'

vim.opt.foldopen = 'block,hor,insert,jump,mark,percent,quickfix,search,tag,undo'

-- }}}

-- Filetype plugins and indentation {{{

-- Don't defer it because it might break `FileType` related autocommands
-- vim.cmd([[filetype plugin indent on]])

-- }}}

-- Custom commands {{{

vim.cmd([[augroup CustomSettings]])
vim.cmd([[autocmd!]])

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=o]])
-- But insert comment leader after hitting <CR> and respect 'numbered' lists
vim.cmd([[autocmd FileType * setlocal formatoptions+=r formatoptions+=n]])

-- Start integrated terminal already in insert mode
-- vim.cmd([[autocmd TermOpen * startinsert]])
vim.cmd([[augroup END]])

-- }}}

--stylua: ignore end
