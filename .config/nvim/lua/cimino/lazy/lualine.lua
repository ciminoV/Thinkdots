return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "gruvbox", -- lualine theme
				component_separators = { left = " ", right = " " },
				section_separators = { left = " ", right = " " },
				disabled_filetypes = { -- Filetypes to disable lualine for.
					statusline = {}, -- only ignores the ft for statusline.
					winbar = {}, -- only ignores the ft for winbar.
				},

				always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
				-- can't take over the entire statusline even
				-- if neither of 'x', 'y' or 'z' are present.

				globalstatus = true, -- enable global statusline (have a single statusline
				-- at bottom of neovim instead of one for  every window).

				refresh = { -- sets how often lualine should refresh it's contents (in ms)
					statusline = 1000, -- The refresh option sets minimum time that lualine tries
					tabline = 1000, -- to maintain between refresh. It's not guarantied if situation
					winbar = 1000, -- arises that lualine needs to refresh itself before this time
					-- it'll do it.
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icons_enabled = true,
					},
				},
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
					},
					{
						"diagnostics",
						-- Displays diagnostics for the defined severity types
						sections = { "error", "warn", "info", "hint" },
						symbols = { error = "E", warn = "W", info = "I", hint = "H" },
						colored = true,
					},
				},
				lualine_c = { "buffers" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		},
	},
}
