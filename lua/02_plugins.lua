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
			"mason-org/mason-lspconfig.nvim",
			opts = {},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
			},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
			},
		},

		{ "echasnovski/mini.files", version = false, setup = true },

		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{ "mbbill/undotree" },
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
			config = function()
				vim.cmd("colorscheme tokyonight-day")
			end,
		},
		{
			"kdheepak/lazygit.nvim",
			keys = {
				{ "<leader>lz", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			},
		},
		{ "f-person/git-blame.nvim" },
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"seblyng/roslyn.nvim",
			---@module 'roslyn.config'
			---@type RoslynNvimConfig
			opts = {
				-- your configuration comes here; leave empty for default settings
			},
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	},
	-- automatically check for plugin updates
	checker = {
		enabled = false, -- disabling auto check
		notify = false, --notify on update
	},
})
