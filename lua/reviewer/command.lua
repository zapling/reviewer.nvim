local git = require('reviewer.git')
local config = require('reviewer.config')
local diffview = require('diffview')

local M = {
    _review_provider = nil,
}

local init_provider = function(git_context)
    if M._review_provider ~= nil then
        return true
    end

    local provider_config = config.get_provider(git_context.host)
    if provider_config ~= nil then
        local provider = provider_config.get_provider()
        local success = provider.setup(provider_config.opts, git_context)
        if success == true then
            M._review_provider = provider
        end
    end
    return true
end

M.start_review = function()
    local git_context = git.get_current_context()
    if git_context == nil then
        vim.api.nvim_echo({
            {'Reviewer: Not in a git repository', 'ErrorMsg'}
        }, false, {})
        return false
    end

    if not init_provider(git_context) then
        vim.api.nvim_echo({
            {'Reviewer: Failed to init provider', 'ErrorMsg'},
        }, false, {})
    end

    local merge_base = git.get_merge_base(git_context.branch.current, git_context.branch.main)
    diffview.open(merge_base)
end

M.list_reviews = function()
    local git_context = git.get_current_context()
    if git_context == nil then
        vim.api.nvim_echo({
            {'Reviewer: Not in a git repository', 'ErrorMsg'}
        }, false, {})
        return false
    end

    if not init_provider(git_context) then
        vim.api.nvim_echo({
            {'Reviewer: Failed to init provider', 'ErrorMsg'},
        }, false, {})
    end

    local list = M._review_provider.list_merge_requests()
    if list == nil then
        vim.api.nvim_echo({
            {'Reviewer: No merge requests to review', 'ErrorMsg'},
        }, false, {})
        return
    end

    local display_list = {}
    for _,v in pairs(list) do
        table.insert(display_list, v.title)
    end

    vim.ui.select(display_list, {
        prompt = 'Select merge request to review',
    }, function(_, index)
        print(index)
    end)

    -- TODO: save selected merge request info for later use?
end

M.stop_review = function()
    diffview.close()
end

return M
