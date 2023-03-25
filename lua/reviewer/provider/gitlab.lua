local M = {}

M.setup = function(opts)
    print('Hello world ' .. vim.inspect(opts))
end

return M
