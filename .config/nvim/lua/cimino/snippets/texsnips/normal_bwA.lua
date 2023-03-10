local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local bwA = {
	s({ trig = "ali", name = "Align" }, { t({ "\\begin{align*}", "\t" }), i(1), t({ "", ".\\end{align*}" }) }),

	ls.parser.parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),

	ls.parser.parse_snippet({ trig = "case", name = "cases" }, "\\begin{cases}\n\t$1\n\\end{cases}"),

	s({ trig = "bigfun", name = "Big function" }, {
		t({ "\\begin{align*}", "\t" }),
		i(1),
		t(":"),
		t(" "),
		i(2),
		t("&\\longrightarrow "),
		i(3),
		t({ " \\", "\t" }),
		i(4),
		t("&\\longmapsto "),
		i(1),
		t("("),
		i(4),
		t(")"),
		t(" = "),
		i(0),
		t({ "", ".\\end{align*}" }),
	}),

	s("figh", {
		t({ "\\begin{figure}[ht]", "" }),
		t({ "\\begin{center}", "" }),
		t("\\includegraphics[width=0.55\\textwidth]{"),
		i(1),
		t({ "}", "" }),
		t({ "\\end{center} ", "" }),
		t("\\caption{"),
		i(2),
		t({ "}", "" }),
		t("\\label{fig:"),
		i(0),
		t({ "}", "" }),
		t("\\end{figure}"),
	}),

  -- Normal equation
	s("eq", {
		t({ "\\begin{equation}", "\t" }),
		i(0),
		t({ "", ""}),
		t("\\label{eq:"),
		i(1),
		t({ "}", "" }),
		t("\\end{equation}"),
	}),

  -- Aligned equation
	s("aeq", {
		t({ "\\begin{equation*}", "\t" }),
		t({ "\\begin{split}", "\t" }),
		i(2, "x(t)"),
		t(" &= "),
		i(0),
		t({ " \\\\", "\t"}),
		t({ "\\end{split} ", "\t" }),
		t("\\label{eq:"),
		i(1),
		t({ "}", "" }),
		t("\\end{equation*}"),
	}),

  -- System of equations
	s("seq", {
		t({ "\\[", "\t" }),
		i(1, "x(t)"),
		t(" = "),
		t({ " \\left\\{\\begin{array}{@{}lr}", "\t"}),
		i(0),
    t({ "", ""}),
		t({ "\\end{array}\\right.", "" }),
		t("\\]"),
  }),
}

return bwA
