local M = {}

M.pipe = function(fns)
  return function(...)
    for _, fn in ipairs(fns) do
      if not fn(...) then
        return false
      end
    end

    return true
  end
end

M.no_backslash = function(line_to_cursor, matched_trigger)
  return not line_to_cursor:find("\\%a+$", -#line_to_cursor)
end

M.is_math = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

M.not_math = function()
  return not M.is_math()
end

M.comment = function()
  return vim.fn["vimtex#syntax#in_comment"]() == 1
end

M.env = function(name)
  local x, y = unpack(vim.fn["vimtex#env#is_inside"](name))
  return x ~= "0" and y ~= "0"
end

M.with_priority = function(snip, priority)
  snip.priority = priority
  return snip
end

M.with_opts = function(fn, opts)
  return function()
    return fn(opts)
  end
end

return M
