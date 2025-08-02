-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "ellisonleao/gruvbox.nvim",
      config = false --configured in settings.lua
    },

    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },
    { "windwp/nvim-autopairs",            config = true },
    { "stevearc/conform.nvim",            opts = {} },
    { "nvim-treesitter/nvim-treesitter",  branch = "master",                                                  lazy = false, build = ":TSUpdate" },
    { "mfussenegger/nvim-dap" },
    { "mfussenegger/nvim-dap-python" },
    { "rcarriga/nvim-dap-ui",             dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    { "rcarriga/nvim-notify" },
    { "ray-x/lsp_signature.nvim",         config = true },
    { "akinsho/toggleterm.nvim",          config = true }
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
