local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
  return
end

catppuccin.setup({
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

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
