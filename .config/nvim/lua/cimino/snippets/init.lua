local ls = require("luasnip")

-- JSON SNIPPETS
ls.add_snippets("json", require("./cimino/snippets/jsonsnips"))

-- LATEX SNIPPETS
-- The following convention is used for naming lua tables and respective files:
-- A: Automatic snippet expansion - snippets will activate as soon as their trigger
-- matches.
-- w: Word boundary - With this option the snippet trigger will match when the
-- trigger is a word boundary character. This is the default behavior.
-- b: Beginning of line expansion - A snippet with this option is expanded only if
-- the trigger is the first word on the line (i.e., only whitespace precedes the
-- trigger).
-- i: Inword expansion - Triggers are also expanded in the middle of a word.
-- r: Regular expression 
local autosnippets = {}

for _, snips in ipairs(require("./cimino/snippets/texsnips/normal_b")) do
   table.insert(autosnippets, snips)
end

for _, snips in ipairs(require("./cimino/snippets/texsnips/normal_wA")) do
   table.insert(autosnippets, snips)
end

for _, snips in ipairs(require("./cimino/snippets/texsnips/normal_bwA")) do
   table.insert(autosnippets, snips)
 end

ls.add_snippets("tex", autosnippets, {
    type = "autosnippets",
})
