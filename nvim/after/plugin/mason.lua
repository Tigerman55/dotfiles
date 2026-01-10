require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "intelephense", "jsonls", "lua_ls" },
})

require("mason-nvim-dap").setup({
    ensure_installed = { "js" },
    automatic_installation = true,
})
