local ls = require("luasnip")
local conds = require("luasnip.extras.expand_conditions")

ls.config.setup({ enable_autosnippets = true })


-- JSON SNIPPETS
ls.add_snippets("json", require("./user/snippets/jsonsnips"))

-- MARKDOWN SNIPPETS
ls.add_snippets("markdown", require("./user/snippets/mdsnips"))


-- LATEX SNIPPETS
-- The following convention is used for naming lua tables and respective files:
-- 
-- A: Automatic snippet expansion - snippets will activate as soon as their trigger
-- matches.
-- 
-- w: Word boundary - With this option the snippet trigger will match when the
-- trigger is a word boundary character. This is the default behavior.
-- 
-- b: Beginning of line expansion - A snippet with this option is expanded only if
-- the trigger is the first word on the line (i.e., only whitespace precedes the
-- trigger).
--
-- i: Inword expansion - Triggers are also expanded in the middle of a word.
--
-- r: Regular expression 

local utils = require("user.snippets.util.utils")
local pipe = utils.pipe
local is_math = utils.with_opts(utils.is_math)
local not_math = utils.with_opts(utils.not_math)

local texsnipspets = {}

for _, snip in ipairs(require("./user/snippets/texsnips/math_i")) do
  snip.condition = pipe({ is_math })
  snip.show_condition = is_math
  snip.wordTrig = false
  table.insert(texsnipspets, snip)
end

for _, snip in ipairs(require("./user/snippets/texsnips/normal_b")) do
  snip.condition = pipe({ conds.line_begin, not_math })
  table.insert(texsnipspets, snip)
end

ls.add_snippets("tex", texsnipspets, { default_priority = 0 })
ls.add_snippets("markdown", texsnipspets, { default_priority = 0 })

-- LATEX AUTOSNIPPETS
local autosnippets = {}

for _, snip in ipairs(require("./user/snippets/texsnips/math_rA")) do
  snip.wordTrig = false
  snip.regTrig = true
  snip.condition = pipe({ is_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/texsnips/normal_wA")) do
  snip.condition = pipe({ not_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/texsnips/math_wrA")) do
  snip.regTrig = true
  snip.condition = pipe({ is_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/texsnips/math_wA")) do
  snip.condition = pipe({ is_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/texsnips/math_iA")) do
  snip.wordTrig = false
  snip.condition = pipe({ is_math })
  table.insert(autosnippets, snip)
end

for _, snip in ipairs(require("./user/snippets/texsnips/normal_bwA")) do
  snip.condition = pipe({ conds.line_begin, not_math })
  table.insert(autosnippets, snip)
end

ls.add_snippets("tex", autosnippets, {
  type = "autosnippets",
  default_priority = 0,
})
