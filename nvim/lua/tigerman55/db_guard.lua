local M = {}

local function db_name_from_key(db_key_name)
    if type(db_key_name) ~= 'string' or db_key_name == '' then
        return nil
    end

    local suffixes = {
        '_g:dbs',
        '_file',
        '_env',
        '_dotenv',
    }

    local db_name = db_key_name
    for _, suffix in ipairs(suffixes) do
        if db_name:sub(-#suffix) == suffix then
            db_name = db_name:sub(1, #db_name - #suffix)
            break
        end
    end

    return db_name
end

function M.buffer_has_write_query(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local sql = table.concat(lines, '\n'):lower() .. '\n'

    sql = sql:gsub('%-%-.-\n', '\n')

    local write_heads = {
        insert = true,
        update = true,
        delete = true,
        replace = true,
        alter = true,
        drop = true,
        truncate = true,
        create = true,
    }

    for stmt in sql:gmatch('[^;]+') do
        local head = stmt:match('^%s*(%a+)')
        if head and write_heads[head] then
            return true
        end

        if head == 'with' then
            if stmt:find('%f[%a]insert%f[%A]')
                or stmt:find('%f[%a]update%f[%A]')
                or stmt:find('%f[%a]delete%f[%A]')
                or stmt:find('%f[%a]replace%f[%A]') then
                return true
            end
        end
    end

    return false
end

function M.is_named_db_connection(bufnr, wanted_names)
    local db_key_name = vim.b[bufnr].dbui_db_key_name
    local db_name = db_name_from_key(db_key_name)
    if not db_name then
        return false
    end

    for _, wanted_name in ipairs(wanted_names or {}) do
        if db_name == wanted_name then
            return true
        end
    end

    return false
end

function M.register_write_guard(opts)
    local config = opts or {}
    local group = vim.api.nvim_create_augroup(config.augroup or 'db_write_guard', { clear = true })

    vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = '*DBExecutePre',
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()

            if not M.is_named_db_connection(bufnr, config.protected_db_names) then
                return
            end

            if not M.buffer_has_write_query(bufnr) then
                return
            end

            local choice = vim.fn.confirm(
                config.confirm_text or 'Write query detected. Continue?',
                '&Yes\n&No',
                2
            )

            if choice ~= 1 then
                error(config.cancel_error or 'DB: cancelled write query')
            end
        end,
    })
end

return M
