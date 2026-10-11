vim.pack.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
    version = vim.version.range("^9"),
  },
})

local conform = require("conform")

conform.setup({
  notify_on_error = false,

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,

  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    cpp = { "clang_format" },
    go = { "gofumpt" },
    tcl = { "tclsp" },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({
    async = true,
    lsp_format = "fallback",
  })
end, {
  desc = "[F]ormat buffer",
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- :FormatDisable! disables formatting only for the current buffer
    vim.b.disable_autoformat = true
  else
    -- :FormatDisable disables formatting globally
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
