local source = {}

local function get_next_id()
  local bufnr = vim.api.nvim_get_current_buf()

  local parser = vim.treesitter.get_parser(bufnr, "json")
  local tree = parser:parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.parse(
    "json",
    [[
			(object
				(pair
					key: (string) @key
					(#eq? @key "\"id\"")
					value: (number) @value
				)
			)
		]]
  )

  local max_id = 0

  for _, match, _ in query:iter_matches(root, bufnr) do
    for id, nodes in pairs(match) do
      if query.captures[id] == "value" and nodes[1] then
        local text = vim.treesitter.get_node_text(nodes[1], bufnr)
        local value = tonumber(text)

        if value then
          max_id = math.max(max_id, value)
        end
      end
    end
  end

  return max_id + 1
end

function source.new()
  return setmetatable({}, { __index = source })
end

function source:get_completions(ctx, callback)
  if vim.bo[ctx.bufnr].filetype ~= "json" then
    callback({
      items = {},
      is_incomplete_forward = false,
      is_incomplete_backward = false,
    })
    return
  end

  local next_id = get_next_id()

  callback({
    items = {
      {
        label = "book",
        kind = vim.lsp.protocol.CompletionItemKind.Snippet,
        insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,

        insertText = string.format(
          [[{
  "id": %d,
  "title": "${1}",
  "author": "${2}",
  "publisher": "${3}",
  "edition": ${4:0},
  "series": "${5}",
  "year": ${6},
  "pages": ${7},
  "ISBN": "${8}",
  "printed": ${9},
  "tags": ["${10}", "${11}", "${12}"]
},]],
          next_id
        ),
      },
    },

    is_incomplete_forward = false,
    is_incomplete_backward = false,
  })
end

return source
