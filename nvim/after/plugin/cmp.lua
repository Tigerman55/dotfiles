local cmp = require("cmp")

cmp.setup({
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
