local M = {}

local default_config = {
    providers = {
        gitlab = {
            host = 'gitlab.com',
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

return M
