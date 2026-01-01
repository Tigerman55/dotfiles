require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "intelephense", "jsonls" }, -- automatically install Intelephense
})
