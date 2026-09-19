-- I use blink.cmp for completion, but you can use native completion too
local completion = vim.g.completion_mode or "blink" -- or 'native' for built-in completion

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    if client then
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
      end

      -- Jump to the definition of the word under your cursor.
      map("gd", vim.lsp.buf.definition, "Go to Definition")

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      -- -- Find references for the word under your cursor.
      map("gr", vim.lsp.buf.references, "Go to References")

      -- -- Jump to the implementation of the word under your cursor.
      map("gi", vim.lsp.buf.implementation, "Go to Implementation")

      -- Rename the variable under your cursor.
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame symbol")

      -- Opens a popup that displays documentation about the word under your cursor
      map("K", vim.lsp.buf.hover, "Hover Documentation")

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")


      -- Built-in completion
      if completion == "native" and client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      end

      -- Inlay hints
      if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end

      if client:supports_method("textDocument/documentColor") then
        vim.lsp.document_color.enable(true, { bufnr = buf }, {
          style = "virtual",
        })
      end

    end -- end if client
  end -- end callback
})

-- Lua Server (lua-language-server)
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luacheckrc", ".git" },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".clang-format", ".git" },
})

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
})

vim.lsp.enable({
  "lua_ls",
  "clangd",
  "pyright"
})
