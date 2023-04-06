local config = require('reviewer.config')
local command = require('reviewer.command')

local M = {}

local cmd = function(opts)
    if opts.args == "" or opts.args == "start" then
        return command.start_review()
    end

    if opts.args == "stop" then
        return command.stop_review()
    end

    if opts.args == "list" then
        return command.list_reviews()
    end
end

M.setup = function(cfg)
    config.set(cfg)
    vim.api.nvim_create_user_command('Review', function(opts) cmd(opts) end, { nargs = '?' })
end

return M
