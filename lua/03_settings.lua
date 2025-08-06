require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (or "all")
	ignore_install = { "javascript" },

	highlight = {
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

require("mini.files").setup()

-- Telescope
local ok, telescope = pcall(require, "telescope")
local actions = require("telescope.actions")
if ok then
	telescope.setup({
		defaults = {
			file_ignore_patterns = { "node_modules", ".git/" },
			mappings = {
				i = {
					["<ESC>"] = actions.close,
				},
			},
		},
		pickers = {
			find_files = {
				hidden = true, --Show hidden files (dotfiles)
				no_ignore = true, -- Don't respect .gitignore
				follow = true, -- Follow symlinks
			},
		},
	})
end

-- Conform
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = {
			-- To fix auto-fixable lint errors.
			"ruff_fix",
			-- To run the Ruff formatter.
			"ruff_format",
			-- To organize the imports.
			"ruff_organize_imports",
		},
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- DAP
local dap = require("dap")

dap.adapters.python = {
	type = "executable",
	command = "python",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}", -- This means: run current file
		pythonPath = function()
			return "python" -- Or set your venv path here
		end,
	},
}
require("nvim-dap-virtual-text").setup({
	-- optional settings
	commented = true, -- show virtual text as comments
})

-- CMP
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = {
				globals = { "vim" }, -- Recognize `vim` as a global
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

lspconfig.pyright.setup({
	settings = {
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			},
		},
	},
})
