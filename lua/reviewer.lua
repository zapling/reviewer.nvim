local M = {}

local command = function(opts)
    local git_context = require('reviewer.git').get_current_context()
    print(vim.inspect(git_context))
end

M.setup = function()
    vim.api.nvim_create_user_command("Review", function(opts) command(opts) end, { nargs = "?" })
end

return M
