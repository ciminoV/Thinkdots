local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local mdsnips = {
  s("cpp", {
    t {"```cpp", " "},
    i(0),
    t { "", "" },
    t "```",
  }),
}

return mdsnips
