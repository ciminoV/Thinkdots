function ColorMyPencils(color)
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)

	-- Configure highlights
	vim.cmd.hi("Comment gui=none")
end

return {
	{
		"tjdevries/colorbuddy.nvim",
		config = function()
			ColorMyPencils("gruvbuddy")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			require("catppuccin").setup({
				flavour = "frappe",
				background = {
					light = "latte",
					dark = "frappe",
				},
				transparent_background = false,
				term_colors = true,
				dim_inactive = {
					enabled = true,
					shade = "dark",
					percentage = 0.5,
				},
				styles = {
					comments = {},
					conditionals = {},
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				integrations = {
					cmp = true,
					telescope = true,
				},
			})
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				styles = {
					italic = false,
				},
			})
		end,
	},
}
