require("colorbuddy").colorscheme("gruvbuddy")

local colorbuddy = require("colorbuddy")
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
--local g = colorbuddy.groups
local s = colorbuddy.styles

Color.new("white", "#f2e5bc")
Color.new("red", "#cc6666")
Color.new("pink", "#fef601")
Color.new("green", "#99cc99")
Color.new("yellow", "#e5c890")
Color.new("blue", "#81a2be")
Color.new("aqua", "#8ec07c")
Color.new("cyan", "#8abeb7")
Color.new("purple", "#8e6fbd")
Color.new("violet", "#b294bb")
Color.new("orange", "#de935f")
Color.new("brown", "#a3685a")

Color.new("seagreen", "#698b69")
Color.new("turquoise", "#698b69")

local background_string = "#111111"
Color.new("background", background_string)

Group.new("Normal", c.superwhite, c.gray0)
Group.new("Conceal", c.superwhite, nil, nil)
Group.new("Character", c.cyan)
Group.new("PreProc", c.violet)
Group.new("Comment", c.gray3:dark(), nil, s.none)
Group.new("Statement", c.brown)
Group.new("Special", c.purple:light(), nil, s.none)

Group.new("@variable", c.superwhite, nil)
Group.new("@variable.builtin", c.purple:light(), nil, s.bold) -- built-in variable names (e.g. `this`)

Group.new("@constant", c.orange, nil, s.none)
Group.new("@constant.macro", c.orange, nil, s.none)

Group.new("@type", c.violet, nil, s.none)
Group.new("@type.builtin", c.violet, nil, s.none)
Group.new("@type.definition", c.violet, nil, s.bold) -- identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)
Group.new("@type.qualifier", c.violet, nil, s.none)

Group.new("@function", c.blue, nil, s.none)
Group.new("@constructor", c.blue, nil, s.bold)

Group.new("@module", c.superwhite, nil, s.none) -- modules or namespaces

Group.new("@keyword", c.yellow, nil, s.none)
Group.new("@keyword.conditional", c.violet, nil, s.none) -- keywords related to conditionals (e.g. `if` / `else`)
Group.new("@keyword.repeat", c.violet, nil, s.none) -- keywords related to loops (e.g. `for` / `while`)

Group.new("@label", c.pink)
