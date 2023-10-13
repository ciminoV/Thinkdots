local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local not_math = utils.with_opts(utils.not_math, false)

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local M = {
	s({ trig = "dm", snippetType = "autosnippet", priority = 10 }, {
		t({ "", "" }),
		t({ "\\[", "" }),
		i(1),
		t({ "", "" }),
		t({ "\\]", "" }),
		i(0),
	}, { condition = not_math }),
}

return M
