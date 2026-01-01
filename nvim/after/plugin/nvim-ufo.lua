vim.o.foldlevel = 99   -- Using ufo provider need a large value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        if filetype == 'php' then
            return { 'lsp', 'indent' }
        end

        if filetype == "typescript"
            or filetype == "typescriptreact"
            or filetype == "javascript"
            or filetype == "javascriptreact"
        then
            return { "lsp", "treesitter" }
        end

        return { 'treesitter', 'indent' }
    end,
    close_fold_kinds_for_ft = {
        php = { 'imports' },
        typescript = { 'imports' },
        typescriptreact = { 'imports' },
        javascript = { 'imports' },
        javascriptreact = { 'imports' },
    }
})

