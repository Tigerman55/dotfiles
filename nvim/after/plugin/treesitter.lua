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
    "twig"
}

