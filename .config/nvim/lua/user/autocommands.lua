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

-- Enable spell check  for specific file types
vim.api.nvim_create_autocmd( { "FileType"}, {
  pattern = { "text", "markdown", "tex" },
  callback = function ()
    vim.cmd "setlocal spell spelllang=it,en,cjk"
  end,
})

-- Enable text conceal for specific file types
vim.api.nvim_create_autocmd( { "FileType" }, {
  pattern = {"tex", "markdown"},
  callback = function ()
    vim.opt.conceallevel = 1
  end,
})

-- Compile on save specific files
vim.api.nvim_create_autocmd( { "BufWritePost" }, {
  pattern = {"PTLC*.md"},
  callback = function ()
    vim.cmd [[:silent  !computils %]]
  end,
})
