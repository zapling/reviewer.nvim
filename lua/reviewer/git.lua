local util = require('reviewer.util')
local Job = require('plenary.job')

local M = {}

local get_parsed_origin_url = function()
    local origin_url = nil
    Job:new({
      command = 'git',
      args = { 'config', '--get', 'remote.origin.url' },
      on_exit = function(j, exit_code)
        if exit_code ~= 0 then
            return
        end

        origin_url = j:result()[1]
      end,
    }):sync()

    if origin_url == nil then
        return nil
    end

    local host = util.get_substr(origin_url, "@.+:")
    local namespace = util.get_substr(origin_url, ":.+/")
    local repo = util.get_substr(origin_url, "/.+%.git")

    if host == "" or namespace == "" or repo == "" then
        return ""
    end

    host = host:sub(2, host:len()-1)                -- remove starting "@" and ending ":"
    namespace = namespace:sub(2, namespace:len()-1) -- remove starting ":" and ending "/"
    repo = repo:sub(2, repo:len()-4)                -- remove starting "/" and ending ".git"

    local parts = {
        host = host,
        namespace = namespace,
        repo = repo,
    }

    return parts
end

local get_current_branch = function()
    local branch = nil
    Job:new({
        command = "git",
        args = { "branch", "--show-current" },
        on_exit = function(j, exit_code)
            if exit_code ~= 0 then
                return
            end

            branch = j:result()[1]
        end,
    }):sync()
    return branch
end


M.get_current_context = function()
    local origin = get_parsed_origin_url()
    if origin == nil then
        return nil
    end

    local branch = get_current_branch()
    if branch == nil then
        return nil
    end

    return {
        host = origin.host,
        namespace = origin.namespace,
        repo = origin.repo,
        branch = branch,
    }
end

return M
