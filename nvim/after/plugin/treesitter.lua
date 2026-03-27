local ts = require('nvim-treesitter')

ts.setup {
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    }
}

ts.install {
    "sql",
    "dockerfile",
    "make",
    "html",
    "css",
    "php",
    "phpdoc",
    "json",
    "javascript",
    "typescript",
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "twig",
    "svelte"
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact" },
    callback = function()
        vim.treesitter.start()
        require("otter").activate({ "sql" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "svelte" },
    callback = function()
        vim.treesitter.start()
    end,
})
