require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "intelephense", "jsonls" },
})

require("mason-nvim-dap").setup({
    ensure_installed = { "js" },
    automatic_installation = true,
})
