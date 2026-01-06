require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "intelephense", "jsonls" }, -- automatically install Intelephense
})

require("mason-nvim-dap").setup({
  ensure_installed = { "js-debug-adapter" },
  automatic_installation = true,
})
