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

vim.api.nvim_create_user_command(
    "Gc",
    function(opts)
        vim.cmd("G commit -m " .. vim.fn.shellescape(opts.args))
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


