local M = {}

function M.urlencode(str)
    return (str:gsub("([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

return M
