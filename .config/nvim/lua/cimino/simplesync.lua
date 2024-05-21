local script_path = vim.fn.expand("$HOME") .. "/documents/simplesync/"

vim.api.nvim_create_user_command("NoteSync", "!sudo python3 " .. script_path .. "sync.py", {})

vim.api.nvim_create_user_command("NoteUpdate", "!sudo python3 " .. script_path .. "update.py <q-args>", { nargs = 1 })

vim.api.nvim_create_user_command("NoteRemove", "!sudo python3 " .. script_path .. "remove.py <q-args>", { nargs = 1 })

local simple_augroup = vim.api.nvim_create_augroup("simplesync", { clear = false })
local note_path = vim.fn.expand("$HOME") .. "/documents/notes/"

--vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--	pattern = { note_path .. "*.md" },
--  group = simple_augroup,
--  callback = function ()
--    vim.cmd.NoteSync()
--  end
--})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave" }, {
	pattern = { note_path .. "*.md" },
  group = simple_augroup,
  callback = function ()
    local file_name = vim.fn.expand("<afile>")
    vim.cmd.NoteUpdate(file_name)
  end
})
