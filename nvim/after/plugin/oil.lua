require("oil").setup({
    cleanup_delay_ms = 5 * 60 * 1000, -- 5 minutes
    default_file_explorer = true,
    keymaps = {
        ["<C-p>"] = false,
    },
    view_options = {
        show_hidden = true,
    }
});
