-- Shorter function name
local keymap = vim.keymap.set

-- Remap space as leader key
vim.g.mapleader = " "

-- Open netrw
keymap("n", "<leader>e", vim.cmd.Ex)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>")
keymap("n", "<C-Down>", ":resize -2<CR>")
keymap("n", "<C-Left>", ":vertical resize -2<CR>")
keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")

-- Move around
keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Copy/paste done well
keymap("x", "<leader>p", "\"_dP")

-- Markdown files
keymap("n", "mc", ":! computils %<CR><CR>")
keymap("n", "mv", ":! opout %<CR><CR>")

-- Nice remaps
keymap("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
keymap("n", "<C-i>", "<C-a>")

-- VimTex
keymap("n", "<leader>vv", ":VimtexView<CR>")
keymap("n", "<leader>vc", ":VimtexCompile<CR>")
keymap("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u") -- spell check on the fly
