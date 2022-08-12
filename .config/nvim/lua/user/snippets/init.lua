local ls = require("luasnip")
local conds = require("luasnip.extras.expand_conditions")

local utils = require("user.snippets.util.utils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash

local is_math = utils.with_opts(utils.is_math)
local not_math = utils.with_opts(utils.not_math)

ls.config.setup({ enable_autosnippets = true })

-- TEXT SNIPPETS
ls.add_snippets("tex", {
  ls.parser.parse_snippet(
    { trig = "pac", name = "Package" },
    "\\usepackage[${1:options}]{${2:package}}$0"
  ),
})

-- MATH SNIPPETS
local math_i = require("./user/snippets/math_i")
for _, snip in ipairs(math_i) do
  snip.condition = pipe({ is_math })
  snip.show_condition = is_math
  snip.wordTrig = false
end

ls.add_snippets("tex", math_i, { default_priority = 0 })

-- MATH AUTOSNIPPETS
local autosnippets = {}

for _, snip in ipairs(require("./user/snippets/math_wRA_no_backslash")) do
  snip.regTrig = true
  snip.condition = pipe({ is_math, no_backslash })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/math_rA_no_backslash")) do
  snip.wordTrig = false
  snip.regTrig = true
  snip.condition = pipe({ is_math, no_backslash })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/normal_wA")) do
  snip.condition = pipe({ not_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/math_wrA")) do
  snip.regTrig = true
  snip.condition = pipe({ is_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/math_wA_no_backslash")) do
  snip.condition = pipe({ is_math, no_backslash })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/math_iA")) do
  snip.wordTrig = false
  snip.condition = pipe({ is_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/math_iA_no_backslash")) do
  snip.wordTrig = false
  snip.condition = pipe({ is_math, no_backslash })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/math_bwA")) do
  snip.condition = pipe({ conds.line_begin, is_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/bwA")) do
  snip.condition = pipe({ conds.line_begin, not_math })
  table.insert(autosnippets, snip)
end

ls.add_snippets("tex", autosnippets, {
  type = "autosnippets",
  default_priority = 0,
})
