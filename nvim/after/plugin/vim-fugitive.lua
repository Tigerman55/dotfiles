vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

vim.api.nvim_create_user_command(
    "Ga",
    function(opts)
        if #opts.fargs == 0 then
            vim.cmd("G add .")
        else
            vim.cmd("G add " .. table.concat(opts.fargs, " "))
        end
    end,
    { nargs = "*" }
)

local function unquote(s)
    s = vim.fn.trim(s)
    local q = s:sub(1, 1)

    if (q == "'" or q == '"') and s:sub(-1) == q then
        return s:sub(2, -2)
    end

    return s
end

vim.api.nvim_create_user_command(
    "Gc",
    function(opts)
        local msg = unquote(opts.args)
        vim.cmd("G commit -m " .. vim.fn.shellescape(msg))
    end,
    { nargs = 1 }
)

vim.api.nvim_create_user_command(
    "Gp",
    function(opts)
      vim.cmd("G push")
    end,
    { nargs = 0 }
)


