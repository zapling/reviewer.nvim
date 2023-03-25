local git = require('reviewer.git')
local diffview = require('diffview')

local M = {}

M.start_review = function()
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

M.stop_review = function()
    diffview.close()
end

return M
