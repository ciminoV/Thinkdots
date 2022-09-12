local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local sn = ls.sn
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

-- Get the last element id and increment it (the elements are in descent order)
local get_last_id = function(position)
  -- dynamic node which return a text node
  return d(position, function()
    local bufnr = vim.api.nvim_get_current_buf()

    local language_tree = vim.treesitter.get_parser(bufnr)
    local syntax_tree = language_tree:parse()
    local root = syntax_tree[1]:root()

    -- treesitter query to match all the ids
    local q = vim.treesitter.parse_query("json",
                                        [[
                                        (object
                                          (pair
                                            value: (number) @value
                                          )
                                        ) 
                                        ]])

    local result = {}
    for _, match, _ in q:iter_matches(root, bufnr, root:start(), root:end_()) do
      table.insert(result, vim.treesitter.query.get_node_text(match[1], bufnr))
    end

    -- Increase the last element
    local my_id = tostring(tonumber(result[5])+1)
    return sn(nil, t(my_id))
  end, {})
end

local jsonsnip = {
  -- add a new book
  s("book",
    fmt(
      [[
      {{
        "id": {},
        "title": "{}",
        "author": "{}",
        "publisher": "{}",
        "edition": "{}",
        "year": {},
        "pages": {},
        "ISBN": "{}",
        "ebook": {},
        "tags": ["{}","{}","{}"]
      }}, 
      ]], {
        get_last_id(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        i(10),i(11),i(0) })
  ),
}

return jsonsnip
