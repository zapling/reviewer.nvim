local M = {
    _client = nil,
    _project_id = nil
}

M.setup = function(opts, git_context)
    M._client = require('reviewer.provider.gitlab.client')
    M._client.base_url = opts.base_url
    M._client.access_token = opts.access_token

    local project = M._client.get_project(git_context.repo)
    if project ~= nil then
        M._project_id = project[1]['id']
    end

    return project ~= nil
end

M.list_merge_requests = function()
    local merge_requests = M._client.get_project_merge_requests(M._project_id)
    if merge_requests == nil then
        return nil
    end

    local list = {}
    for _, v  in pairs(merge_requests) do
        local merge_request = {
            title = v.title,
        }
        table.insert(list, merge_request)
    end

    return list
end

return M
