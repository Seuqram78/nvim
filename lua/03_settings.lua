require("mini.files").setup()
require("mini.indentscope").setup()
require("mini.cursorword").setup()
require("mini.diff").setup()
local map = require("mini.map")
local map_integrations = {
	map.gen_integration.builtin_search(),
	map.gen_integration.diagnostic({
		error = "DiagnosticFloatingError",
		warn = "DiagnosticFloatingWarn",
		info = "DiagnosticFloatingInfo",
		hint = "DiagnosticFloatingHint",
	}),
}
map.setup({
	symbols = {
		encode = map.gen_encode_symbols.dot("4x2"),
	},
	integrations = map_integrations,
})
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		MiniMap.open()
	end,
})

-- Harpoon tabline: build one lualine component per slot
local harpoon_slots = require("harpoon_slots")
local harpoon_tabline_components = {}
for i, key in ipairs(harpoon_slots) do
	harpoon_tabline_components[i] = {
		function()
			local Marks = require("harpoon-core.mark")
			local marks = Marks.get()
			local filename = marks[i] and marks[i].filename or "[empty]"
			return key .. ": " .. filename
		end,
		color = function()
			local Marks = require("harpoon-core.mark")
			local active_idx = Marks.index()
			if active_idx == i then
				return "TabLineSel"
			end
			-- Dim empty slots more than occupied ones
			local marks = Marks.get()
			if not marks[i] then
				return { fg = "#5c5c5c", bg = "NONE" }
			end
			return "TabLine"
		end,
		separator = { left = "", right = "" },
		padding = { left = 2, right = 2 },
	}
end

require("lualine").setup({
	options = {
		always_show_tabline = true,
	},
	sections = {
		lualine_c = { { "filename", path = 1 } },
	},
	tabline = {
		lualine_a = harpoon_tabline_components,
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})

require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"angularls",
		"bashls",
		"docker_language_server",
		"emmylua_ls",
		"helm_ls",
		"jsonls",
		"markdown_oxide",
		"omnisharp",
		"basedpyright",
		"tombi",
		"ts_ls",
		"yamlls",
	},
	automatic_installation = true,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- format/lint tools used by conform
		"stylua",
		"ruff",
		"prettier",
		"kdlfmt",
		"hadolint",
		-- language servers (not managed by mason-lspconfig)
		"roslyn",
		-- debug adapters used by dap
		"debugpy",
		"netcoredbg",
		-- other tools
		"uv",
	},
	run_on_start = true,
	auto_update = false,
})

-- Telescope
local ok, telescope = pcall(require, "telescope")
if ok then
	local actions = require("telescope.actions")
	telescope.setup({
		defaults = {
			file_ignore_patterns = { "node_modules", ".git/", ".venv/" },
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
	telescope.load_extension("cmdline")
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
		typescript = { "prettier" },
		javascript = { "prettier" },
		html = { "prettier" },
		cs = { "lsp" },
		kdl = { "kdlfmt" },
		json = { "jq" },
	},
	formatters = {
		prettier = {
			command = "prettier",
			args = { "--stdin-filepath", "$FILENAME" },
			stdin = true,
		},
	},
	format_on_save = function(bufnr)
		-- local ignore = { "cs", "html", "ts", "typescript", "htmlangular" }
		local ignore = {}
		if vim.tbl_contains(ignore, vim.bo[bufnr].filetype) then
			return
		end
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

-- vim.keymap.set("n", "<leader>zz", function()
-- 	vim.g.disable_autoformat = not vim.g.disable_autoformat
-- 	vim.notify("Format on save (global): " .. (vim.g.disable_autoformat and "OFF" or "ON"))
-- end, { desc = "Toggle format-on-save (global)" })
--
-- DAP
require("dapui").setup({
	layouts = {
		-- Layout 1: scopes + stacks left, repl bottom
		{
			elements = {
				{ id = "scopes", size = 0.5 },
				{ id = "stacks", size = 0.5 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "repl", size = 1.0 },
			},
			size = 15,
			position = "bottom",
		},
		-- Layout 2: scopes + breakpoints + stacks left, repl + console bottom
		{
			elements = {
				{ id = "scopes", size = 0.33 },
				{ id = "breakpoints", size = 0.33 },
				{ id = "stacks", size = 0.33 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "repl", size = 0.5 },
				{ id = "console", size = 0.5 },
			},
			size = 15,
			position = "bottom",
		},
	},
})
local dap = require("dap")

dap.listeners.after.event_initialized["dapui_buflist"] = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.bo[buf].filetype
		if ft:match("^dapui_") or ft == "dap-repl" then
			vim.bo[buf].buflisted = true
		end
	end
end

dap.adapters.python = {
	type = "executable",
	host = "127.0.0.1",
	port = "${port}",
	-- command = "python",
	command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
	args = { "-m", "debugpy.adapter" },
}

dap.adapters.python_attach = function(callback, config)
	callback({
		type = "server",
		host = (config.connect and config.connect.host) or "127.0.0.1",
		port = (config.connect and config.connect.port) or 5678,
	})
end

dap.configurations.python = dap.configurations.python or {}

table.insert(dap.configurations.python, {
	type = "python",
	request = "launch",
	name = "Launch file",
	program = "${file}", -- This means: run current file
	pythonPath = function()
		return "python" -- Or set your venv path here
	end,
})
table.insert(dap.configurations.python, {
	name = "Attach (WSL direct server)",
	type = "python_attach",
	request = "attach",
	connect = { host = "127.0.0.1", port = 5678 },
	justMyCode = false,
})
table.insert(dap.configurations.python, {
	name = "Pytest: current file",
	type = "python",
	request = "launch",
	pythonPath = function()
		return vim.fn.exepath("python")
	end,
	module = "pytest",
	-- args = { "${file}" },
	console = "integratedTerminal",
	justMyCode = false,
})

dap.adapters.coreclr = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			local cwd = vim.fn.getcwd()
			vim.fn.system("dotnet build " .. cwd)
			local project_name = vim.fn.fnamemodify(cwd, ":t")
			local glob = cwd .. "/bin/Debug/net*/" .. project_name .. ".dll"
			local dlls = vim.fn.glob(glob, 0, 1)
			if #dlls > 0 then
				return dlls[1]
			else
				return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
			end
		end,
	},
}

table.insert(dap.configurations.cs, {
	type = "coreclr",
	name = "attach - netcoredbg",
	request = "attach",
	processId = function()
		local pid = vim.fn.input("Process ID: ")
		if pid ~= "" then
			vim.notify("Attaching to PID " .. pid .. "...", vim.log.levels.INFO)
			return tonumber(pid)
		else
			vim.notify("Attach cancelled", vim.log.levels.WARN)
			return nil
		end
	end,
})
require("nvim-dap-virtual-text").setup({
	-- optional settings
	-- commented = true, -- show virtual text as comments
})

vim.lsp.inlay_hint.enable(true)

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				inlayHints = {
					callArgumentNames = "all",
				},
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
			},
		},
	},
})

vim.lsp.config("emmylua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					vim.env.VIMRUNTIME, --gives vim.* types/completion
					vim.fn.stdpath("config"), -- your nvim config
				},
			},
		},
	},
})
