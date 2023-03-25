local M = {
    _client = nil
}

M.setup = function(opts)
    M._client = require('reviewer.provider.gitlab.client')
    M._client.base_url = opts.base_url
    M._client.access_token = opts.access_token

    -- TODO: Is this a good first call?
    local user = M._client.get_current_user()
    print(vim.inspect(user))

    return user ~= nil
end

return M
