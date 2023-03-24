local git = require('reviewer.git')
local diffview = require('diffview')

local M = {}

local command = function(opts)
    local git_context = git.get_current_context()
    if git_context == nil then
        vim.api.nvim_echo({
            {'Reviewer: Not in a git repository', 'ErrorMsg'}
        }, false, {})
        return
    end

    local merge_base = git.get_merge_base(git_context.branch.current, git_context.branch.main)
    diffview.open(merge_base)
end

M.setup = function()
    vim.api.nvim_create_user_command('Review', function(opts) command(opts) end, { nargs = '?' })
end

return M
