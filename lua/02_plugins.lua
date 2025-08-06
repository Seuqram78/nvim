require("lazy").setup({
	spec = {
		{ "windwp/nvim-autopairs", config = true },
		{ "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "stevearc/conform.nvim", opts = {} },
		{ "mfussenegger/nvim-dap" },
		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"mfussenegger/nvim-dap",
				"nvim-neotest/nvim-nio",
			},
			config = function()
				require("dapui").setup({
					layouts = {
						{
							elements = { "scopes", "stacks" },
							size = 40,
							position = "left",
						},
						{
							elements = { "repl", "console" },
							size = 40,
							position = "right",
						},
					},
				})
			end,
		},
		{ "theHamsta/nvim-dap-virtual-text" },
		{ "akinsho/toggleterm.nvim", version = "*", config = true },

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
			"williamboman/mason.nvim",
			build = ":MasonUpdate",
			config = true,
		},
		{ "echasnovski/mini.files", version = false, setup = true },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{ "mbbill/undotree" },
	},
	-- automatically check for plugin updates
	checker = { enabled = true },
})
