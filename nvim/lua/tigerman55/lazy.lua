-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({

  -- Lazy itself (optional in Lazy.nvim, but included for clarity)
  { "folke/lazy.nvim" },

  -- file-level structure tool (Treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require'nvim-treesitter'.setup{
	        ensure_installed = {"dockerfile", "make", "html", "css", "php", "phpdoc", "json", "javascript", "typescript", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

	        -- Install parsers synchronously (only applied to `ensure_installed`)
	        sync_install = false,

	        -- Automatically install missing parsers when entering buffer
	        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	        auto_install = true,

	        highlight = {
	            enable = true,
	            additional_vim_regex_highlighting = false,
	        },
	        indent = {
	            enable = true,
	        }
        }
    end
  },

  -- file telescoping (Telescope)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
  },

  -- git in nvim
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Gcommit", "Gstatus" },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Mason: LSP/DAP/Formatter/Linter installer
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- Autocomplete base
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
  },
  { "hrsh7th/cmp-nvim-lsp", dependencies = "nvim-cmp" },
  { "hrsh7th/cmp-buffer",   dependencies = "nvim-cmp" },
  { "hrsh7th/cmp-path",     dependencies = "nvim-cmp" },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets", -- optional
    },
    event = "InsertEnter",
  },
  -- Phpactor (for import class, refactoring, etc.)
  {
  "phpactor/phpactor",
  build = "composer install --no-dev -o",
  ft = "php",
  },
    {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    },
    {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
    "nvim-tree/nvim-web-devicons",
    },
    config = function()
    require("nvim-tree").setup {}
    end,
    },
    {'b0o/SchemaStore.nvim'},
    -- in your plugins list
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "│",
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
                include = {
                    node_type = {
                        php = {
                            "array_creation_expression",
                            "object_creation_expression",
                            "class_declaration",
                            "method_declaration",
                            "function_definition",
                        },
                    },
                },
            },
        },
    },
    {'RRethy/vim-illuminate'},
    {'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async'},
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {
            -- specific options usually not required, but here is how to force the slash behavior
            enable_close_on_slash = true, 
            enable_close = true, -- Auto close tags
            enable_rename = true, -- Auto rename pairs of tags
            enable_close_on_slash = true -- Auto close on trailing </
        },
        config = function(_, opts)
            require('nvim-ts-autotag').setup({ opts = opts })
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
    },
    {
        "karb94/neoscroll.nvim",
        opts = {},
    },
    {
        "stevearc/oil.nvim",
        dependencies = {{ "nvim-mini/mini.icons", opts = {} }},
    },
    {
        "tpope/vim-dadbod",
        cmd = { "DB", "DBUI", "DBUIToggle" }
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = { "tpope/vim-dadbod" },
        cmd = { "DBUI", "DBUIToggle" },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "tpope/vim-dadbod" },
        ft = { "sql", "mysql" },
    },
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
        opts = {
            ensure_installed = { "js-debug-adapter" },
            automatic_installation = true,
        },
    },
})

