return {
	"akinsho/toggleterm.nvim",
	version = "*",
	require("toggleterm").setup({
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
	}),

	vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>"),
	vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>"),
}
