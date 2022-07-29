local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {"bash", "lua", "bibtex", "c", "haskell", "python", "yaml"},
	ignore_install = { "latex" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	autopairs = {
		enable = true,
    },
    indent = { enable = true, disable = { "python", "css" } },
})
