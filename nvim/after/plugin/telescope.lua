local nvim_start_cwd = vim.loop.cwd()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function()
    require("telescope.builtin").find_files({
        cwd = nvim_start_cwd,
        hidden = true,
        no_ignore = true,
    })
end, { desc = 'Telescope find files' })

vim.keymap.set("n", "<C-p>", function()
    require("telescope.builtin").git_files({
        show_untracked = true,
        hidden = true,
    })
end, { desc = "Telescope find files" })


--[[vim.keymap.set("n", "<C-p>", function()
  builtin.find_files({
    find_command = { "fd", "--type", "f", "--hidden", "--follow" },
  })
end, { desc = "Telescope: find all files (Git-aware)" })]] --
vim.keymap.set("v", "<leader>fg", function()
    -- Get selected text
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))

    local lines = vim.fn.getline(ls, le)
    if #lines == 0 then return end

    lines[#lines] = string.sub(lines[#lines], 1, ce) -- trim end
    lines[1] = string.sub(lines[1], cs)            -- trim start

    local query = table.concat(lines, " ")

    -- Open Telescope live_grep with default text
    require('telescope.builtin').live_grep({ default_text = query })
end, { desc = "Live grep with visual selection" })

-- directory grep (works in normal buffers + oil buffers)
vim.keymap.set("n", "<leader>dg", function()
    local dir

    if vim.bo.filetype == "oil" then
        dir = require("oil").get_current_dir()
    else
        dir = vim.fn.expand("%:p:h")
    end

    require("telescope.builtin").live_grep({
        search_dirs = { dir },
    })
end, { desc = "live grep inside active directory" })

-- Don't list terminal buffers (so Telescope buffers won't show them)
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("hide_term_from_telescope", { clear = true }),
    callback = function(args)
        vim.bo[args.buf].buflisted = false
    end,
})

vim.keymap.set("n", "<C-h>", function()
    require("telescope.builtin").buffers({
        show_all_buffers = false, -- only listed buffers
        sort_mru = true,
        ignore_current_buffer = true,
    })
end, { desc = "Buffers from this session (files only)" })

vim.keymap.set("n", "<leader>nd", function()
    local builtin = require("telescope.builtin")

    -- Optional: try to use the git root as cwd
    local git_root = vim.fs.root(0, { ".git" }) or vim.loop.cwd()

    builtin.find_files({
        prompt_title = "Git Tracked Directories",
        cwd = git_root,
        find_command = {
            "git",
            "-C", git_root,
            "ls-tree",
            "-d",
            "-r",
            "--name-only",
            "HEAD",
        },
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local actions = require("telescope.actions")
                local state = require("telescope.actions.state")
                local entry = state.get_selected_entry()
                actions.close(prompt_bufnr)

                local rel = entry.value
                local abs = vim.fs.joinpath(git_root, rel)

                -- Option A: Lua API
                require("oil").open(abs)

                -- Option B (instead): command
                -- vim.cmd("Oil " .. vim.fn.fnameescape(abs))
            end)
            return true
        end,
    })
end)

vim.keymap.set("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
end, { desc = "Search text in project (live grep)" })

vim.keymap.set("n", "<leader>fw", function()
    require("telescope.builtin").grep_string()
end, { desc = "Search word under cursor" })
