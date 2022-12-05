local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local b = {

	ls.parser.parse_snippet({ trig = "pac", name = "Package" }, "\\usepackage[${1:options}]{${2:package}}$0"),

	s("template", {
		t({ "\\documentclass[a4paper]{article}", "" }),
		t({ "", "" }),
		t({ "\\usepackage[utf8]{inputenc}", "" }),
		t({ "\\usepackage{amsmath, amssymb}", "" }),
		t({ "\\usepackage{imakeidx}", "" }),
		t({ "\\usepackage{graphicx}", "" }),
		t({ "\\graphicspath{ {./images/} }", "" }),
		t({ "", "" }),
		t("\\title{"),
		i(1),
		t({ "}", "" }),
		t("\\author{"),
		i(2, "Vincenzo Cimino"),
		t({ "}", "" }),
		t("\\date{"),
		i(3, os.date("%Y")),
		t({ "}", "" }),
		t({ "", "" }),
		t({ "\\begin{document}", "" }),
		t({ "\\begin{titlepage}", "" }),
		t({ "\\maketitle", "" }),
		t({ "\\end{titlepage}", "" }),
		t({ "", "" }),
		t({ "\\tableofcontents", "" }),
		t({ "", "" }),
		t({ "\\clearpage", "" }),
		t({ "", "" }),
		i(0),
		t({ "", "" }),
		t({ "", "" }),
		t({ "\\end{document}", "" }),
	}),

  s("exercise", {
    t("\\textbf{\\textit{Exercise"),
    i(1),
    t({ "}}", ""}),
    t({ "", ""}),
    t({ "\\begin{tcolorbox}[colback=lightgray!50]", ""}),
    i(2),
    t({ "", ""}),
    t({ "\\end{tcolorbox}", ""}),
    t({ "", ""}),
    i(3),
    t({ "", ""}),
    t({ "\\par\\noindent\\rule{\\textwidth}{0.4pt}", ""}),
    t({ "", ""}),
    i(0),
  }),
}

return b
