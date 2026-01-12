local M = {}

local function load_env()
    local environment = {}

    local home = os.getenv("HOME") or ""
    local path = home .. "/.config/nvim/.env.local"

    local env_file = assert(io.open(path, 'rb'), '.env.local needs to exist')

    for line in env_file:lines() do
        -- skip blank lines and comments
        if not line:match("^%s*$") and not line:match("^%s*#") then
            local key, value = line:match('^%s*([%w_]+)%s*=%s*"(.*)"%s*$')
            if key and value then
                environment[key] = value
            end
        end
    end

    env_file:close()

    return environment
end

M.vars = load_env()

return M
