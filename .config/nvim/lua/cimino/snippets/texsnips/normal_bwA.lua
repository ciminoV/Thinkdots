local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local conds = require("luasnip.extras.expand_conditions")
local pipe = utils.pipe

local not_math = utils.with_opts(utils.not_math, false)

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local M = {
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
	}, {condition = pipe({conds.line_begin, not_math})}),

  -- Normal equation
	s("eq", {
		t({ "\\begin{equation}", "\t" }),
		i(0),
		t({ "", ""}),
		t("\\label{eq:"),
		i(1),
		t({ "}", "" }),
		t("\\end{equation}"),
	}, {condition = pipe({conds.line_begin, not_math})}),

  -- Aligned equation
	s("aeq", {
		t({ "\\begin{equation*}", "\t" }),
		t({ "\\begin{split}", "\t" }),
		i(1, "x(t)"),
		t(" &= "),
		i(0),
		t({ " \\\\", "\t"}),
		t({ "\\end{split} ", "" }),
		t("\\end{equation*}"),
	}, {condition = pipe({conds.line_begin, not_math})}),

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
  }, {condition = pipe({conds.line_begin, not_math})}),
}

return M
