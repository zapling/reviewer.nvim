local curl = require('plenary.curl')
local log = require('reviewer.log')
local util = require('reviewer.util')

local mask_private_token = function(object)
    object = util.tbl_deep_clone(object)
    if object and object.headers.private_token ~= nil then
        object.headers.private_token = '***MASKED***'
    end
    return object
end

local M = {
    base_url = 'https://gitlab.com',
    access_token = ''
}

M._request = function(endpoint, method, body)
    local url = string.format('%s/api/v4/%s', M.base_url, endpoint)

    local http_request = {
        url = url,
        method = method,
        accept = 'application/json',
        headers = {
            private_token = M.access_token,
        }
    }

    if body ~= nil then
        http_request.body = body
    end

    log.debug('(gitlab) http request: ' .. vim.inspect(mask_private_token(http_request)))

    local response = curl.request(http_request)

    log.debug('(gitlab) http response: ' .. vim.inspect(response))

    return response
end

-- https://docs.gitlab.com/ee/api/users.html#for-non-administrator-users-1
M.get_current_user = function()
    local response = M._request("user", "GET", nil)
    if response ~= nil and response.status == 200 then
        return vim.fn.json_decode(response.body)
    end
    return nil
end

-- https://docs.gitlab.com/ee/api/projects.html#search-for-projects-by-name
M.get_project = function(name)
    local endpoint = 'projects?search='  .. name
    local response = M._request(endpoint, "GET", nil)
    if response ~= nil and response.status == 200 then
        return vim.fn.json_decode(response.body)
    end
    return nil
end

-- https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests
M.get_project_merge_requests = function(project_id)
    local endpoint = 'projects/' .. project_id .. '/merge_requests?state=opened'
    local response = M._request(endpoint, 'GET', nil)
    if response ~= nil and response.status == 200 then
        return vim.fn.json_decode(response.body)
    end
    return nil
end

return M
