local M = {}

M.get_substr = function(text, pattern)
    local i, j = string.find(text, pattern)

    if not i then
        return ''
    end

    return text:sub(i, j)
end

return M
