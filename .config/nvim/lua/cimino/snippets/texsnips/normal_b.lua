local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local conds = require("luasnip.extras.expand_conditions")
local pipe = utils.pipe

local not_math = utils.with_opts(utils.not_math, false)

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local M = {
	s("template", {
		t({ "\\documentclass[a4paper,11pt]{article}", "" }),
		t({ "", "" }),
		t({ "\\usepackage[utf8]{inputenc}", "" }),
		t({ "\\usepackage{amsmath, amssymb}", "" }),
		t({ "\\usepackage{imakeidx}", "" }),
		t({ "\\usepackage{graphicx}", "" }),
		t({ "\\usepackage{fancyhdr}", "" }),
		t({ "\\graphicspath{ {./images/} }", "" }),
		t({ "%%%%%%%%%%%%%%%%%% Margins %%%%%%%%%%%%%%%%%%%%%%", "" }),
		t({ "\\topmargin = 0cm", "" }),
		t({ "\\evensidemargin = -1cm", "" }),
		t({ "\\oddsidemargin = -1cm", "" }),
		t({ "\\textheight = 23cm", "" }),
		t({ "\\textwidth = 18cm", "" }),
		t({ "", "" }),
		t({ "%%%%%%%%%%%%%%%%%% Margins %%%%%%%%%%%%%%%%%%%%%%", "" }),
		t({ "\\renewcommand{\\familydefault}{phv}", "" }),
		t({ "", "" }),
		t({ "%%%%%%%%%%%%%%%%%% Numbering equation with respect to section %%%%%%%%%%%%%%%%%%%%%%", "" }),
		t({ "\\numberwithin{equation}{subsection}", "" }),
		t({ "", "" }),
		t({ "\\let\\oldsection\\section% Store \\section", "" }),
		t({ "\\renewcommand{\\section}{% Update \\section", "" }),
		t({ "  \\renewcommand{\\theequation}{\\thesection.\\arabic{equation}}% Update equation number", "" }),
		t({ "  \\oldsection}% Regular \\section", "" }),
		t({ "\\let\\oldsubsection\\subsection% Store \\subsection", "" }),
		t({ "\\renewcommand{\\subsection}{% Update \\subsection", "" }),
		t({ "  \\renewcommand{\\theequation}{\\thesubsection.\\arabic{equation}}% Update equation number", "" }),
		t({ "  \\oldsubsection}% Regular \\subsection", "" }),
		t({ "%%%%%%%%%%%%%%%%%% Numbering equation with respect to section %%%%%%%%%%%%%%%%%%%%%%", "" }),
		t({ "", "" }),
		t({ "%%%%%%%%%%%%%%%%%% Pages header %%%%%%%%%%%%%%%%%%%%%%", "" }),
		t({ "\\pagestyle{fancy}", "" }),
		t({ "\\fancyhf{}", "" }),
		t({ "\\fancyhead[LE,RO]{\\leftmark}", "" }),
		t({ "\\fancyhead[LO,RE]{\\rightmark}", "" }),
		t({ "\\setlength{\\headheight}{5pt}", "" }),
		t({ "%%%%%%%%%%%%%%%%%% Pages header %%%%%%%%%%%%%%%%%%%%%%", "" }),
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
	}, { condition = pipe({ conds.line_begin, not_math }) }),

	s("exercise", {
		t("\\textbf{\\textit{Exercise"),
		i(1),
		t({ "}}", "" }),
		t({ "", "" }),
		t({ "\\begin{tcolorbox}[colback=lightgray!50]", "" }),
		i(2),
		t({ "", "" }),
		t({ "\\end{tcolorbox}", "" }),
		t({ "", "" }),
		i(3),
		t({ "", "" }),
		t({ "\\par\\noindent\\rule{\\textwidth}{0.4pt}", "" }),
		t({ "", "" }),
		i(0),
	}, { condition = pipe({ conds.line_begin, not_math }) }),

	s("example", {
		t({ "", "" }),
		t({ "\\par\\noindent\\rule{\\textwidth}{0.4pt}", "" }),
		t({ "", "" }),
		t("\\textbf{\\textit{Example"),
		i(1),
		t({ "}} ", "\\textit{" }),
		i(2),
		t({ "}", "" }),
		i(3),
		t({ "", "" }),
		t({ "\\par\\noindent\\rule{\\textwidth}{0.4pt}", "" }),
		t({ "", "" }),
		i(0),
	}, { condition = pipe({ conds.line_begin, not_math }) }),
}

return M
