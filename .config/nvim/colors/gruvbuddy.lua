require("colorbuddy").colorscheme("gruvbuddy")

local colorbuddy = require("colorbuddy")
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups
local s = colorbuddy.styles

Color.new("white", "#f2e5bc")
Color.new("red", "#cc6666")
Color.new("pink", "#fef601")
Color.new("green", "#99cc99")
Color.new("yellow", "#f8fe7a")
Color.new("blue", "#81a2be")
Color.new("aqua", "#8ec07c")
Color.new("cyan", "#8abeb7")
Color.new("purple", "#8e6fbd")
Color.new("violet", "#b294bb")
Color.new("orange", "#de935f")
Color.new("brown", "#a3685a")

Color.new("seagreen", "#698b69")
Color.new("turquoise", "#698b69")

local background_string = "#282c34"
Color.new("background", background_string)
Color.new("gray0", background_string)

Group.new("Normal", c.superwhite, c.gray0)
Group.new("NormalFloat", c.superwhite, c.gray0)
Group.new("Comment", c.gray4:dark(), nil, s.none)
Group.new("Conceal", c.superwhite, nil, nil)
Group.new("LineNr", c.gray2, c.gray0)
Group.new("PreProc", c.violet)
Group.new("Statement", c.brown)
Group.new("StorageClass", c.yellow)
Group.new("Visual", nil, c.blue:dark(0.1))
Group.new("VisualLineMode", g.Visual, g.Visual)
Group.new("VisualMode", g.Visual, g.Visual)

-- @variable ; various variable names
Group.new("@variable", g.Normal)
-- @variable.builtin ; built-in variable names (e.g. `this`)
Group.new("@variable.builtin", c.purple:light(), nil, s.bold)
-- @variable.parameter  ; parameters of a function
-- @variable.member     ; object and struct fields

-- @constant          ; constant identifiers
Group.new("@constant", c.orange, nil, s.bold)
-- @constant.builtin  ; built-in constant values
-- @constant.macro    ; constants defined by the preprocessor

-- @module            ; modules or namespaces
Group.new("@module", c.white)
-- @module.builtin    ; built-in modules or namespaces

-- @character              ; character literals
Group.new("Character", c.cyan)

-- @type             ; type or class definitions and annotations
Group.new("Type", c.blue, nil, s.none)
-- @type.builtin     ; built-in types
Group.new("@type.builtin", g.type, nil, s.none)
-- @type.qualifier   ; type qualifiers (e.g. `const`)
Group.new("@type.qualifier", g.type, nil, s.none)
-- @type.definition  ; identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)
Group.new("@type.definition", g.type, nil, s.italic)

-- @function             ; function definitions
Group.new("@function", c.cyan, nil, s.none)

Group.new("@keyword", c.violet) -- ; keywords not fitting into specific categories
Group.new("@keyword.repeat", c.blue) -- ; keywords not fitting into specific categories
-- @keyword.repeat            ; keywords related to loops (e.g. `for` / `while`)
-- @keyword.conditional         ; keywords related to conditionals (e.g. `if` / `else`)
