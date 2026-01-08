local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
    layouts = {
        {
            position = "left",
            size = 75,
            elements = {
                { id = "scopes",      size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
        },
        --[[{
            position = "bottom",
            size = 12, -- height in lines for top/bottom layouts
            elements = { "repl", "console" },
        },]]--
    }
})

vim.keymap.set("n", "<leader>du", dapui.toggle)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
    -- Eval var under cursor
    vim.keymap.set("n", "<space>?", function()
    dapui.eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F13>", dap.restart)

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
