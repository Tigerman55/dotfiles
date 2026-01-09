-- LSP capabilities (for nvim-cmp)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("intelephense", {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php" },
  root_markers = { "composer.json", ".git", ".intelephense" },
  flags = { debounce_text_changes = 300 },
  init_options = {
    licenceKey = os.getenv("INTELEPHENSE_KEY"),
  },
  capabilities = capabilities,

  settings = {
    intelephense = {
      diagnostics = {
        typeErrors = false,
      },
    },
  },
})

vim.lsp.config("jsonls", {
    settings = {
        json = {
            format = {
                enable = true,
            },
            validate = {
                enable = true,
            },
            schemas = require("schemastore").json.schemas({
                select = {
                    "package.json",
                    "tsconfig.json",
                    ".eslintrc",
                },
            }),
        },
    },
})

-- keeping in case we use eslint in the future
--[[vim.lsp.config("eslint", {
    on_attach = function(client, bufnr)
        -- leave these to typescript-tools LSP
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.renameProvider = false
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.documentSymbolProvider = false
        client.server_capabilities.workspaceSymbolProvider = false
        client.server_capabilities.signatureHelpProvider = false
    end,
    settings = {
        workingDirectory = { mode = "auto" },
    },
})]]--

vim.lsp.enable({"intelephense","jsonls"})

-- keymaps
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename variable" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })

vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {
  noremap = true,
  silent = true,
  desc = "LSP: Find references",
})
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, { desc = 'Format Document' })
