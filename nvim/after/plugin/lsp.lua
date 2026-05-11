local env = require 'tigerman55.env'.vars

-- LSP capabilities (for nvim-cmp)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- document colors are breaking things right now, temp fix
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.lsp.document_color.enable(false, { bufnr = ev.buf })

        if vim.bo[ev.buf].filetype == "svelte" then
            vim.schedule(function()
                vim.lsp.semantic_tokens.enable(false, { bufnr = ev.buf })
            end)
        end
    end,
})

vim.lsp.config("intelephense", {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php" },
    root_markers = { "composer.json", ".git", ".intelephense" },
    flags = { debounce_text_changes = 300 },
    init_options = {
        licenceKey = env.INTELEPHENSE_KEY,
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
        -- leave these to TypeScript LSP
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
})]] --

-- init.lua
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Get the language server to recognize the `vim` global and other Neovim globals
            diagnostics = {
                globals = { 'vim' },
            },
            runtime = {
                -- Tell the language server which version of Lua you're using
                version = 'LuaJIT',
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- Twig LSP Configuration
vim.lsp.config("twiggy_language_server", {
    cmd = { "twiggy-language-server", "--stdio" },
    filetypes = { "twig" },
    -- Sharing the capabilities you already defined for cmp-nvim-lsp
    capabilities = capabilities,
    settings = {
        twiggy = {
            -- Add any specific twiggy settings here if needed
        }
    }
})

vim.lsp.config("svelte", {
    capabilities = capabilities,
    filetypes = { "svelte" },
    on_attach = function(client)
        client.server_capabilities.renameProvider = false
    end,
})

vim.lsp.config("ts_ls", {
    capabilities = capabilities,
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
    },
    init_options = {
        plugins = {
            {
                name = "typescript-svelte-plugin",
                location = vim.fn.stdpath("data") .. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin",
                languages = { "svelte" },
            },
        },
    },
})

vim.lsp.config("cssls", {
    capabilities = capabilities,
    settings = {
        css = {
            lint = {
                unknownAtRules = "ignore",
            },
        },
        scss = {
            lint = {
                unknownAtRules = "ignore",
            },
        },
        less = {
            lint = {
                unknownAtRules = "ignore",
            },
        },
    },
})

vim.lsp.config("tailwindcss", {
    capabilities = capabilities,
    filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
    },
    settings = {
        tailwindCSS = {
            validate = true,
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
            },
        },
    },
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.js", "*.ts" },
    callback = function(ctx)
        for _, client in ipairs(vim.lsp.get_clients({ name = "svelte" })) do
            client:notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_fname(ctx.match) })
        end
    end,
})

-- Update your enable list to include twiggy_language_server
vim.lsp.enable({ "intelephense", "jsonls", "lua_ls", "twiggy_language_server", "svelte", "cssls", "tailwindcss", "ts_ls" })

-- keymaps
local function dedupe_lsp_list(opts, by_line)
    local seen = {}

    opts.items = vim.tbl_filter(function(item)
        local key_parts = by_line
            and { item.filename or item.bufnr or "", item.lnum or "" }
            or {
                item.filename or item.bufnr or "",
                item.lnum or "",
                item.col or "",
                item.end_lnum or "",
                item.end_col or "",
            }
        local key = table.concat(key_parts, "\31")

        if seen[key] then
            return false
        end

        seen[key] = true
        return true
    end, opts.items)

    if vim.tbl_isempty(opts.items) then
        vim.notify("No locations found", vim.log.levels.INFO)
        return
    end

    vim.fn.setqflist({}, " ", opts)

    if #opts.items == 1 then
        vim.cmd.cfirst()
    else
        vim.cmd.copen()
    end
end

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename variable" })
vim.keymap.set("n", "<leader>gd", function()
    vim.lsp.buf.definition({
        on_list = function(opts)
            dedupe_lsp_list(opts, true)
        end,
    })
end, { desc = "Go to definition" })

vim.keymap.set("n", "<leader>gr", function()
    vim.lsp.buf.references(nil, {
        on_list = function(opts)
            dedupe_lsp_list(opts, false)
        end,
    })
end, {
    noremap = true,
    silent = true,
    desc = "LSP: Find references",
})

vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, { desc = 'Format Document' })
