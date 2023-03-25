local M = {}

local default_config = {
    providers = {
        gitlab = {
            host = 'gitlab.com',
            get_provider = function()
                return require('reviewer.provider.gitlab')
            end,
            opts = {
                base_url = 'https://gitlab.com',
                access_token = '',
            }
        },
    },
    debug = {
        logger = {
            use_file = false,
        }
    }
}

M._config = default_config

M.set = function(cfg)
    M._config = vim.tbl_deep_extend("force", M._config, cfg or {})
end

M.get = function()
    return M._config
end

M.get_provider = function(git_host)
    for _, v in pairs(M._config.providers) do
        if v.host == git_host then
            return v
        end
    end
    return nil
end

return M
