-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ' '

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Open netrw
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-H>', '<C-w><C-H>', { desc = 'Move focused window to the left' })
vim.keymap.set('n', '<C-L>', '<C-w><C-L>', { desc = 'Move focused window to the right' })
vim.keymap.set('n', '<C-J>', '<C-w><C-J>', { desc = 'Move focused window to the bottom' })
vim.keymap.set('n', '<C-K>', '<C-w><C-K>', { desc = 'Move focused window to the top' })


-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- Move around
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Markdown files
vim.keymap.set("n", "mc", ":! computils %<CR><CR>")
vim.keymap.set("n", "mv", ":! opout %<CR><CR>")

-- Nice remaps
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- VimTex
vim.keymap.set("n", "<leader>vv", ":VimtexView<CR>")
vim.keymap.set("n", "<leader>vc", ":VimtexCompile<CR>")
vim.keymap.set("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u") -- spell check on the fly
