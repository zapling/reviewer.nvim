local M = {}

local command = function(opts)
    vim.api.nvim_echo({
        {"Hello World"}
    }, false, {})
end

M.setup = function()
    vim.api.nvim_create_user_command("Review", function(opts) command(opts) end, { nargs = "?" })
end

return M
