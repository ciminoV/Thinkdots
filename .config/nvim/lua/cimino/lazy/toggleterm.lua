return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {--[[ things you want to change go here]]
			close_on_exit = true,
			direction = "horizontal",
		},
	},
	vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>"),
	vim.keymap.set("n", "<leader>th", ":ToggleTerm<CR>"),
}
