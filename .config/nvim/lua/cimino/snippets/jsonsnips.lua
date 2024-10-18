local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local sn = ls.sn
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

-- Get the last element id and increment it (the elements are in descent order)
local get_last_id = function(position)
	return d(position, function()
		local bufnr = vim.api.nvim_get_current_buf()

		local language_tree = vim.treesitter.get_parser(bufnr)
		local syntax_tree = language_tree:parse()
		local root = syntax_tree[1]:root()

		-- Treesitter query to match all the ids
		local query = vim.treesitter.query.parse(
			"json",
			[[
        (object
          (pair
            key: (string) @key (#eq? @key "\"id\"")
            value: (number) @value
          )
        ) 
      ]]
		)

		local result = {}
		for _, match, _ in query:iter_matches(root, bufnr) do
			if match[2] then
				local id_value = vim.treesitter.get_node_text(match[2], bufnr)
				if id_value then
					table.insert(result, tonumber(id_value))
				end
			end
		end

		-- Increase the last element
		local last_id = result[1] or 0
		local my_id = tostring(last_id + 1)

		return sn(nil, t(my_id))
	end, {})
end

local jsonsnip = {
	-- add a new book
	s(
		"book",
		fmt(
			[[
      {{
        "id": {},
        "title": "{}",
        "author": "{}",
        "publisher": "{}",
        "edition": {},
        "series": "{}",
        "year": {},
        "pages": {},
        "ISBN": "{}",
        "printed": {},
        "tags": ["{}","{}","{}"]
      }}, 
      ]],
			{
				get_last_id(1), -- id
				i(2), -- title
				i(3), -- author
				i(4), -- publisher
				i(5, "0"), -- edition
				i(6), -- series
				i(7), -- year
				i(8), -- pages
				i(9), -- ISBN
				i(10), -- printed
				i(11), -- tags1
				i(12), -- tags2
				i(0), -- tags3
			}
		)
	),
}

return jsonsnip
