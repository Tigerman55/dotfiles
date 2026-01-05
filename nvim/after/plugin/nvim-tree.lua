require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    hijack_directories = {
        enable = false, -- Set to false to prevent automatic opening on directory entry
        auto_open = false, -- Ensure this is also false if you want no auto-opening at all
    },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("Oil")
      return
    end

    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0)
      if vim.fn.isdirectory(arg) == 1 then
        vim.cmd("cd " .. vim.fn.fnameescape(arg))
        vim.cmd("Oil")
      end
    end
  end,
})

vim.keymap.set("n", "<leader>e", function()
  local api = require("nvim-tree.api")

  -- Reveal the current file. If nvim-tree is closed, this opens it.
  api.tree.find_file({
    open = true,
    focus = true,
  })
end, { desc = "NvimTree: focus current file" })
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    hijack_directories = {
        enable = false, -- Set to false to prevent automatic opening on directory entry
        auto_open = false, -- Ensure this is also false if you want no auto-opening at all
    },
    -- Other nvim-tree configurations can go here
})

