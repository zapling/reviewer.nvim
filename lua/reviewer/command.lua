local git = require('reviewer.git')
local config = require('reviewer.config')
local diffview = require('diffview')

local M = {
    _review_provider = nil,
}

M.start_review = function()
    local git_context = git.get_current_context()
    if git_context == nil then
        vim.api.nvim_echo({
            {'Reviewer: Not in a git repository', 'ErrorMsg'}
        }, false, {})
        return
    end

    local provider_config = config.get_provider(git_context.host)
    if provider_config ~= nil then
        local provider = provider_config.get_provider()
        local success = provider.setup(provider_config.opts)
        if success == true then
            M._review_provider = provider
        end
    end

    local merge_base = git.get_merge_base(git_context.branch.current, git_context.branch.main)
    diffview.open(merge_base)
end

M.stop_review = function()
    diffview.close()
end

return M
