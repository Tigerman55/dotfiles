require("illuminate").configure({
    providers = {
        "lsp",
        "treesitter",
        "regex",
    },
    delay = 100, -- Delay in ms before highlighting
    filetypes_denylist = {
        "dirvish",
        "fugitive",
    },
})
