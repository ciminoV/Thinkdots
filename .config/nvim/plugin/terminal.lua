local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		set.number = false
		set.relativenumber = false
		set.scrolloff = 0
	end,
})

vim.keymap.set("t", "<esc><esc>", "<C-\\><C-N>", { silent = true })
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { silent = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { silent = true })

-- Open a terminal at the bottom of the screen with a fixed height.
local term_id = 0
local curr_path = ""
vim.keymap.set("n", "<leader>t", function()
	curr_path = vim.fn.expand("%:h")
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()

	term_id = vim.bo.channel
end, { desc = "Open Terminal" })

-- Compile the current DESERT module.
vim.keymap.set("n", "<leader>md", function()
	curr_path = curr_path:gsub("DESERT_Framework/DESERT/", "")
	curr_path = "DESERT_buildCopy_LOCAL/DESERT-3.5.0-build/" .. curr_path
	vim.fn.chansend(term_id, { "cd " .. curr_path, "make", "", "make install", "" })
end, { desc = "Make the current DESERT module" })
