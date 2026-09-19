vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- Highlight current line
vim.opt.wrap = true -- Wrap lines
vim.opt.scrolloff = 10 -- Keep 8 lines above/below cursor

-- Indentation
vim.opt.tabstop = 4 -- Tab width
vim.opt.shiftwidth = 4 -- Indent width
vim.opt.softtabstop = 4
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true
vim.opt.breakindent = true -- Preserve visual indentation in wrapping

-- Search settings
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show matches as you type

-- Visual settings
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.cmdheight = 1 -- Command line height
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.pumheight = 10 -- Popup menu height
vim.opt.pumblend = 10 -- Popup menu transparency
vim.opt.winblend = 0 -- Floating window transparency
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.concealcursor = "" -- Don't hide cursor line markup
vim.opt.ruler = false -- Disable the default ruler
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.colorcolumn = "80"

-- File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true -- Persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.synmaxcol = 300 -- Syntax highlighting limit
vim.opt.updatetime = 300 -- Faster completion
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000
vim.opt.updatetime = 300 -- Faster completion
vim.opt.autoread = true -- Auto realod files changes outside vim
vim.opt.autowrite = true -- Auto save on changing buffer

-- Behavior settings
vim.opt.hidden = true -- Allow hidden buffers
vim.opt.backspace = "indent,eol,start" -- Better backspace behavior
vim.opt.autochdir = false -- Don't auto change directory
vim.opt.mouse = "a"
vim.opt.fileencoding = "utf-8"
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
vim.opt.inccommand = "split"

-- Folding settings
vim.opt.smoothscroll = true
vim.wo.foldmethod = "expr"
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"

-- Path alias
vim.opt.isfname:append("@-@")
