require("lazy").setup({
  spec = {
    { "windwp/nvim-autopairs",           config = true },
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { "stevearc/conform.nvim",                  opts = {} },
    { "mfussenegger/nvim-dap" },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      },
    },
    { "theHamsta/nvim-dap-virtual-text" },
    { "akinsho/toggleterm.nvim",        version = "*", config = true },

    -- Completion engine
    { "hrsh7th/nvim-cmp" },
    -- LSP source for nvim-cmp
    { "hrsh7th/cmp-nvim-lsp" },
    -- Buffer words source (optional, but useful)
    { "hrsh7th/cmp-buffer" },
    -- File system paths (optional, but lightweight)
    { "hrsh7th/cmp-path" },

    -- Snippet engine (even if unused, some sources expect it)
    { "L3MON4D3/LuaSnip" },

    { "saadparwaiz1/cmp_luasnip" },

    { "neovim/nvim-lspconfig" },

    {
      "mason-org/mason-lspconfig.nvim",
      opts = {},
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      },
    },

    { "echasnovski/mini.files",   version = false, setup = true },

    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { "mbbill/undotree" },
    { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
    {
      "kdheepak/lazygit.nvim",
      keys = {
        { "<leader>lz", "<cmd>LazyGit<cr>", desc = "LazyGit" }
      }
    },
    { "f-person/git-blame.nvim" },
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
      "olimorris/codecompanion.nvim",
      opts = {},
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    { 'github/copilot.vim' },
    -- {
    --   "CopilotC-Nvim/CopilotChat.nvim",
    --   dependencies = {
    --     { "nvim-lua/plenary.nvim", branch = "master" },
    --   },
    --   build = "make tiktoken",
    --   opts = {
    --     -- See Configuration section for options
    --   },
    -- },
    {
      "olimorris/codecompanion.nvim",
      opts = {},
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
  },
  --
  -- automatically check for plugin updates
  checker = { enabled = true },
})
