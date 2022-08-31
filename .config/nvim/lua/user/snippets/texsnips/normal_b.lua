local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local b = {

  ls.parser.parse_snippet(
    { trig = "pac", name = "Package" },
    "\\usepackage[${1:options}]{${2:package}}$0"
  ),


  s("template",
    fmt(
        [[
          \documentclass[a4paper]{{article}}

          \usepackage[utf8]{{inputenc}}
          \usepackage{{amsmath, amssymb}}
          
          \begin{{document}}
            {} 
          \end{{document}}
        ]],
        {i(1)}
    )
  ),
}

return b
