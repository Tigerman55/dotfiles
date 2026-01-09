local api = require("typescript-tools.api")

require("typescript-tools").setup({
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
