vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")
Snacks.setup({
	-- animate = { enabled = false },
	-- layout = { enabled = false },
	-- dashboard = { enabled = false },
	-- dim = { enabled = false },
	-- -- statuscolumn = { enabled = false },
	-- scroll = { enabled = false },
	-- terminal = { enabled = false },
	-- toggle = { enabled = false },
	-- words = { enabled = false },
	-- zen = { enabled = false },
	-- scratch = { enabled = false },                          -- Scratch buffers with a persistent file
	-- explorer = { enabled = false, replace_netrw =  false },    -- File explorer (replace netrw)
	bigfile = { enabled = true },                           -- Deal with big files
	image = { enabled = true },                             -- Image viewer using Kitty Graphics Protoco
	indent = { enabled = true },                            -- Indent guides and scopes
	input = { enabled = true },                             -- Better vim.ui.input
	notifier = { enabled = true },                          -- Pretty vim.notify
	quickfile = { enabled = true },                         -- When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins.
	scope = { enabled = true },                             -- Scope detection, text objects and jumping based on treesitter or indent

	picker = {
		sources = {

			files = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
							["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.idea/*",
					"**/.DS_Store",
					"build/*",
					"coverage/*",
					"dist/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/digest*.txt",
					"**/.node-gyp/**",
				},

			},

			grep = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.venv/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/yarn.lock",
					"build*/*",
					"coverage/*",
					"dist/*",
					"certificates/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/digest*.txt",
					"**/.node-gyp/**",
				},

			},

			grep_buffers = {},

			explorer = {
                win = {
                  -- Keymaps active when navigating the file list
                  list = {
                    keys = {
                      ["l"] = "confirm",
                      ["<CR>"] = "explorer_focus",
                      ["h"] = "explorer_up",
                      ["-"] = "explorer_up",
                    },
                  },
                  -- Keymaps active when typing in the search prompt
                  input = {
                    keys = {
                      ["<Esc>"] = { "close", mode = { "n", "i" } },
                      ["<c-r>"] = { "explorer_rename", mode = { "n", "i" } },
                    },
                  },
                },
				hidden = true,
				ignored = true,
				supports_live = true,
				auto_close = true,
				diagnostics = true,
				diagnostics_open = false,
				focus = "list",
				follow_file = true,
				git_status = true,
				git_status_open = false,
				git_untracked = true,
				jump = { close = true },
				tree = true,
				watch = true,
				exclude = {
					".git",
					".pnpm-store",
					".venv",
					".DS_Store",
					"**/.node-gyp/**",
				},
			}, -- close explorer

		}, -- close sources
	}, -- close pickers
}) -- close Snacks.setup

local keymaps = {

    -- Search files
    { "<leader>ss", function() Snacks.picker.smart() end, desc = "[S]earch [S]mart Find Files" },
    { "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "[S]earch [N]eovim files" },
    { "<leader>sf", function() Snacks.picker.files() end, desc = "[S]earch [F]iles" },
    { "<leader>sg", function() Snacks.picker.git_files() end, desc = "[S]earch [G]it files" },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "[S]earch existing [B]uffers" },
    { "<leader>sr", function() Snacks.picker.recent() end, desc = "[S]earch [R]ecent" },
    { "<leader>sh", function() Snacks.picker.command_history() end, desc = "[S]earch [H]istory" },

    -- Grep on files
    { "<leader>sz", function() Snacks.picker.grep() end, desc = "[S]earch [G]rep" },
    { "<leader>s/", function() Snacks.picker.lines() end, desc = "[S]earch in current buffer" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "[S]election or word", mode = { "n", "x" } },
}

for _, map in ipairs(keymaps) do
	local opts = { desc = map.desc }

	if map.silent ~= nil then
		opts.silent = map.silent
	end

	if map.noremap ~= nil then
		opts.noremap = map.noremap
	else
		opts.noremap = true
	end

	if map.expr ~= nil then
		opts.expr = map.expr
	end

	local mode = map.mode or "n"
	vim.keymap.set(mode, map[1], map[2], opts)
end
