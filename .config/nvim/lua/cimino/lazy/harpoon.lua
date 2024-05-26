return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<c-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		-- set <space>1..<space>5 be my shortcuts to moving to the files
		for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
			vim.keymap.set("n", string.format("<leader>%d", idx), function()
				harpoon:list():select(idx)
			end)
		end

		-- toggle previous & next buffers stored within harpoon list
		vim.keymap.set("n", "<c-l>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<c-h>", function()
			harpoon:list():next()
		end)
	end,
}
