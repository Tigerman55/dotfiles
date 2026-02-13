require("tokyonight").setup({
  style = "night",
  transparent = false,
  terminal_colors = false,
  on_highlights = function(hl, c)
      hl.DiagnosticUnnecessary = { fg = c.magenta2, italic = true }
  end,
})

vim.cmd("colorscheme tokyonight")

