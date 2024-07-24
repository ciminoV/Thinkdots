return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = {
			line_numbers = true,
			multiline_threshold = 2, -- Maximum number of lines to show for a single context
			mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = "-",
		},

		vim.keymap.set("n", "[c", function()
			require("treesitter-context").go_to_context(vim.v.count1)
		end, { desc = "Jump to [C]ontext (upwards)", silent = true }),
	},
}
