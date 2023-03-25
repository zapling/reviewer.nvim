local M = {}

M.get_substr = function(text, pattern)
    local i, j = string.find(text, pattern)

    if not i then
        return ''
    end

    return text:sub(i, j)
end

M.tbl_deep_clone = function(t)
  if not t then
    return
  end
  local clone = {}

  for k, v in pairs(t) do
    if type(v) == "table" then
      clone[k] = M.tbl_deep_clone(v)
    else
      clone[k] = v
    end
  end

  return clone
end

return M
