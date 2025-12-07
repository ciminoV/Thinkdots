-- Fix autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Enable spell check  for specific file types
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "text", "markdown", "tex" },
	callback = function()
		vim.cmd("setlocal spell spelllang=it,en,cjk")
	end,
})

-- Enable text conceal for specific file types
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "tex", "markdown" },
	callback = function()
		vim.opt.conceallevel = 1
	end,
})

-- Disable format on save for specific file types
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "c", "cpp", "cc", "h" },
	callback = function()
		vim.cmd("FormatDisable")
	end,
})
