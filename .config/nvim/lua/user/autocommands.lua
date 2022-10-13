-- Fix autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

-- Enable spell check 
vim.api.nvim_create_autocmd( { "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.tex" },
  callback = function ()
    vim.cmd "setlocal spell spelllang=it,en,cjk"
  end,
})

-- Enable text conceal only in LaTeX & Markdown files
vim.api.nvim_create_autocmd( { "BufRead", "BufNewFile" }, {
  pattern = {"*.tex", "*.md"},
  callback = function ()
    vim.opt.conceallevel = 1
  end,
})

-- Compile specific Markwdown files
vim.api.nvim_create_autocmd( { "BufWritePost" }, {
  pattern = {"PTLC*.md"},
  callback = function ()
    vim.cmd [[:silent  !computils %]]
  end,
})
