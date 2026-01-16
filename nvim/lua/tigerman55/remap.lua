vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { desc = "Open diagnostics float" })
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Switch to last file" })

-- Clear search highlights when pressing <Esc> in Normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>",
    { noremap = true, silent = true, desc = "Clear search highlights" })

vim.api.nvim_create_user_command("DelHere", function()
    vim.cmd(":call delete(expand('%:p')) | bdelete!")
end, { desc = 'Delete the current file from disk and close the buffer' })

-- Copy relative path from project root (git root)
vim.keymap.set("n", "<leader>rp", function()
    -- 1. Find project root (using .git)
    local root = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" })
    if not root then
        print("No project root found")
        return
    end

    -- 2. Current file absolute path
    local abs = vim.fn.expand("%:p")

    -- 3. Produce path relative to root
    local rel = abs:sub(#root + 2)

    -- 4. Copy to clipboard register "+"
    vim.fn.setreg("+", rel)

    print("Copied: " .. rel)
end, { desc = "Copy file path relative to project root" })

vim.keymap.set("v", "<leader>fg", function()
    -- Get selected text
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))

    local lines = vim.fn.getline(ls, le)
    if #lines == 0 then return end

    lines[#lines] = string.sub(lines[#lines], 1, ce) -- trim end
    lines[1] = string.sub(lines[1], cs)              -- trim start

    local query = table.concat(lines, " ")

    -- Open Telescope live_grep with default text
    require('telescope.builtin').live_grep({ default_text = query })
end, { desc = "Live grep with visual selection" })

-- Utility: find PSR-4 namespace candidate from project root
local function derive_namespace(filepath)
    local root = vim.fs.root(filepath, { "composer.json", ".git" })
    if not root then return nil end

    local rel = filepath:sub(#root + 2) -- strip "/root/"
    rel = rel:gsub("/", "\\")           -- convert slashes
    return rel
end

vim.api.nvim_create_user_command("CreatePhpClass", function(opts)
    local class = opts.args
    if class == "" then
        print("Provide a class name: :CreatePhpClass ClassName")
        return
    end

    -- folder of the current buffer
    local folder = vim.fn.expand("%:p:h")
    if folder == "" then
        print("No valid folder detected")
        return
    end

    local file = folder .. "/" .. class .. ".php"

    -- create namespace line
    local ns = derive_namespace(folder)
    local namespace_line = ns and ("namespace " .. ns .. ";") or ""

    local contents = [[<?php

declare(strict_types=1);

]] .. (namespace_line ~= "" and namespace_line .. "\n\n" or "") .. [[final class ]] .. class .. [[
{
    public function __construct()
    {
    }
}
]]

    -- write or overwrite file
    local fd = io.open(file, "w")
    fd:write(contents)
    fd:close()

    vim.cmd("edit " .. file)

    print("Created: " .. file)
end, {
    nargs = 1,
    complete = "file",
})

-- set netrw cwd to the current directory
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function(args)
        local buf = args.buf

        local function netrw_lcd_to_browsed_dir()
            local dir = vim.b[buf].netrw_curdir
            if not dir or dir == "" then return end
            -- critical: don't trigger DirChanged autocmds
            vim.cmd("noautocmd lcd " .. vim.fn.fnameescape(dir))
        end

        -- keep netrw window aligned whenever you enter it
        vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
            buffer = buf,
            callback = netrw_lcd_to_browsed_dir,
        })

        -- optional: manual key, also noautocmd
        vim.keymap.set("n", "<leader>cd", netrw_lcd_to_browsed_dir, {
            buffer = buf,
            desc = "netrw: lcd to browsed dir (noautocmd)",
        })
    end,
})

vim.keymap.set('n', '<C-Del>', function()
    local cur = vim.api.nvim_get_current_buf()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if b ~= cur
            and vim.api.nvim_buf_is_loaded(b)
            and vim.bo[b].buflisted
            and not vim.bo[b].modified
        then
            pcall(vim.api.nvim_buf_delete, b, {})
        end
    end
end, { desc = 'Close other unmodified buffers', silent = true })
