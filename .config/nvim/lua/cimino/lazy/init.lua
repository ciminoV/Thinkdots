return {
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- Undo Tree
	{ "mbbill/undotree" },

	{ "tpope/vim-surround" },

	{ "nvim-treesitter/playground" },

	-- Hex colors highlight
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Latex
	{ "lervag/vimtex" },
	{
		"iurimateus/luasnip-latex-snippets.nvim",
		requires = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
		config = function()
			require("luasnip-latex-snippets").setup({
				use_treesitter = false,
				allow_on_markdown = false,
			})
		end,
	},
}
