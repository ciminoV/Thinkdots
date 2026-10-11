vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },
})

local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Add File to Harpoon" })

vim.keymap.set("n", "<leader>l", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle Harpoon Menu" })

for i = 1, 5 do
  vim.keymap.set("n", string.format("<space>%d", i), function()
    harpoon:list():select(i)
  end, { desc = string.format("Harpoon File %d", i) })
end
