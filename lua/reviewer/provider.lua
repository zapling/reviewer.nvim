local config = require('reviewer.config')

local M = {}

M.get = function(host)
    local providers = config.get().providers
    for _, v in pairs(providers) do
        if v.host == host then
            return v
        end
    end
    return nil
end

return M
