-- Ensure termguicolors is enabled if not already
vim.opt.termguicolors = true

require("nvim-highlight-colors").setup({
    exclude_buffer = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        return ft ~= "css" and ft ~= "scss" and ft ~= "sass"
    end,
})
