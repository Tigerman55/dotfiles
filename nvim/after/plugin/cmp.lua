local cmp = require("cmp")

cmp.setup({
    window = {
        completion = {
            max_width = 100,
        },
    },

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "vim-dadbod-completion" }
    },

    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),

    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
            local ci = entry.completion_item

            -- 1) Prefer the LSP-provided labelDetails.description (newer TS server can send this)
            local origin = ci.labelDetails and ci.labelDetails.description or nil

            -- 2) Fall back to detail (tsserver often puts "Auto import from '...'" here)
            if not origin or origin == "" then
                origin = ci.detail
            end

            -- 3) Clean it up a bit if it's the "Auto import from 'x'" style
            if type(origin) == "string" then
                origin = origin:gsub("^Auto import from%s+", "from ")
            end

            -- If we found anything useful, show it in the right-side menu
            if origin and origin ~= "" then
                vim_item.menu = origin
            else
                -- fallback: show cmp source name (less useful than module, but better than nothing)
                vim_item.menu = ("[%s]"):format(entry.source.name)
            end

            return vim_item
        end,
    },
})

local cmp = require("cmp")
local types = require("cmp.types")

cmp.setup({
    -- your existing config…

    mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- etc...
    },
})
