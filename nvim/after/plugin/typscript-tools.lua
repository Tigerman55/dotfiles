local api = require("typescript-tools.api")

require("typescript-tools").setup({
    handlers = {
        ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
            -- Ignore 'This may be converted to an async function' diagnostics.
            { "6133" }
        ),
    },
    --[[settings = {
        tsserver_path = "./node_modules/typescript/lib/tsserver.js",
        tsserver_file_preferences = {
            noUnusedLocals = false,
            noUnusedParameters = false,
        },
    },]]--
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
});
