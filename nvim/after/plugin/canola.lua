require("oil").setup({
    default_file_explorer = true,
    keymaps = {
        ["<C-p>"] = false,
    },
    view_options = {
        show_hidden = true,
    },
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 2 * 1000,
        autosave_changes = 'unmodified'
    }
});
