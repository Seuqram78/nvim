-- Keybinds optimized for Colemak DH layout
-- Harpoon bindings (hz/hx/hc/hd) use home row keys for ergonomic access

-- Telescope
local builtin = require("telescope.builtin")
local input = vim.fn.input

vim.keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy Find Files" })
vim.keymap.set("n", ":", "<cmd>Telescope cmdline<CR>", { desc = "Cmdline" })
vim.keymap.set("n", "<leader>nn", "<cmd>NoNeckPain<CR>", { desc = "Toggle No Neck Pain" })

vim.keymap.set("n", "<leader>ts", function()
	-- Prompt user for extensions
	local extensions = input("Enter file extension: ")

	-- If blank, search all files
	if extensions == "" then
		builtin.live_grep()
		return
	else
		-- Build ripgrep --glob arguments
		local args = {}
		for extension in string.gmatch(extensions, "[^,]+") do
			table.insert(args, "--glob=*" .. extension)
		end

		-- Run live_grep with extension filter
		builtin.live_grep({ additional_args = args })
	end
end, { desc = "Fuzzy Search" })

vim.keymap.set("n", "<leader>tr", function()
  builtin.buffers({
    sort_mru = false,
    sort_lastused = false,
    sort_buffers = function(a, b)
      local function buffer_name(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        return (name == "" and "[No Name]" or name):lower()
      end

      local name_a, name_b = buffer_name(a), buffer_name(b)
      return name_a == name_b and a < b or name_a < name_b
    end,
  })
end, { desc = "List Buffers Alphabetically" })
vim.keymap.set("n", "<leader>tp", function()
	builtin.treesitter({
		symbols = "function",
		sorting_strategy = "ascending",
	})
end, { desc = "List functions (treesitter)" })
vim.keymap.set("n", "<leader>nei", function()
	require("telescope.builtin").lsp_references()
end, { desc = "Find usages" })

--Harpoon
local harpoon = require("harpoon-core")
local harpoon_slots = require("harpoon_slots")
vim.keymap.set("n", "<leader>hv", function()
	harpoon.add_file()
	require("lualine").refresh()
end, { desc = "Harpoon add" })
vim.keymap.set("n", "<leader>hk", function()
	harpoon.toggle_quick_menu()
end, { desc = "Harpoon toggle" })
for i, key in ipairs(harpoon_slots) do
	vim.keymap.set("n", "<leader>h" .. key, function()
		harpoon.nav_file(i)
	end, { desc = "Harpoon " .. i })
end
vim.keymap.set("n", "<leader>h,", function()
	harpoon.nav_prev()
end, { desc = "Harpoon prev" })
vim.keymap.set("n", "<leader>h.", function()
	harpoon.nav_next()
end, { desc = "Harpoon next" })

-- mini files
vim.keymap.set("n", "<leader>pv", function()
	local MiniFiles = require("mini.files")
	local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	vim.defer_fn(function()
		MiniFiles.reveal_cwd()
	end, 30)
end)

-- mini diff
vim.keymap.set("n", "<leader>gh", function()
	vim.b.minimap_show_diff = not vim.b.minimap_show_diff
	require("mini.diff").toggle_overlay(0)
	MiniMap.refresh({ integrations = {
		vim.b.minimap_show_diff and require("mini.map").gen_integration.diff()
			or require("mini.map").gen_integration.diagnostic(),
	} })
end, { desc = "Toggle git diff overlay" })

-- DAP
local dap = require("dap")
vim.keymap.set("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP: Continue" })

vim.keymap.set("n", "<F6>", function()
	dap.terminate()
end, { desc = "DAP: Terminate" })

vim.keymap.set("n", "<F11>", function()
	dap.step_into()
end, { desc = "DAP: Step Into" })

vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end, { desc = "DAP: Step Over" })

vim.keymap.set("n", "<F8>", function()
	dap.continue()
end, { desc = "DAP: Resume" })

vim.keymap.set("n", "<leader>bb", function()
	dap.toggle_breakpoint()
end, { desc = "DAP: Toggle Breakpoint" })

vim.keymap.set("n", "<F56>", function()
	local width = vim.o.columns
	local height = vim.o.lines - 2
	require("dapui").float_element("repl", { width = width, height = height, enter = true })
end, { desc = "DAP: Open evaluate window" })

-- DAP UI
local dapui = require("dapui")

vim.keymap.set("n", "<leader>dd", function()
	vim.ui.select({ "1: Scopes + Stacks / REPL", "2: Scopes + Breakpoints + Stacks / REPL + Console" }, {
		prompt = "Select DAP UI layout:",
	}, function(_, idx)
		if not idx then
			return
		end
		dapui.close()
		if idx == 1 then
			dapui.open({ layout = 1 })
			dapui.open({ layout = 2 })
		else
			dapui.open({ layout = 3 })
			dapui.open({ layout = 4 })
		end
	end)
end, { desc = "DAP UI Open (pick layout)" })
vim.keymap.set("n", "<leader>dc", function()
	dapui.close()
end, { desc = "DAP UI Close" })

-- Toggleterm
vim.keymap.set("n", "<leader>hh", "<cmd>ToggleTerm direction=float<CR>", { desc = "Open/close floating terminal" })

vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "IncRename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action" })

-- Treehopper (select AST nodes with hints)
vim.keymap.set("o", "m", ":<C-U>lua require('tsht').nodes()<CR>", { silent = true, desc = "Treehopper select" })
vim.keymap.set("x", "m", ":lua require('tsht').nodes()<CR>", { silent = true, desc = "Treehopper select" })

-- LSP status picker: attached clients for the current buffer + Mason-installed
-- servers applicable to it but not (yet) attached.
vim.api.nvim_set_hl(0, "TelescopeLspAttached", { link = "DiagnosticOk", default = true })
vim.api.nvim_set_hl(0, "TelescopeLspAvailable", { link = "Comment", default = true })

vim.keymap.set("n", "<leader>lsp", function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local previewers = require("telescope.previewers")
	local entry_display = require("telescope.pickers.entry_display")

	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype

	local attached = vim.lsp.get_clients({ bufnr = bufnr })
	local attached_names = {}
	for _, client in ipairs(attached) do
		attached_names[client.name] = true
	end

	local entries = {}
	for _, client in ipairs(attached) do
		table.insert(entries, {
			name = client.name,
			status = "attached",
			client = client,
		})
	end

	-- Every installed Mason package, mapped to its lspconfig server name where
	-- one exists (e.g. "json-lsp" -> "jsonls") so it lines up with attached
	-- client names; otherwise shown under its raw package name. This lists
	-- everything Mason shows, LSP or not (formatters, DAPs, linters, ...).
	local pkg_to_lspconfig = {}
	local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")
	if ok_mlsp then
		local ok_map, mappings = pcall(mlsp.get_mappings)
		if ok_map then
			pkg_to_lspconfig = mappings.package_to_lspconfig
		end
	end

	local candidate_names = {}
	local ok_registry, registry = pcall(require, "mason-registry")
	if ok_registry then
		for _, pkg in ipairs(registry.get_installed_package_names()) do
			candidate_names[pkg_to_lspconfig[pkg] or pkg] = true
		end
	end

	for name in pairs(candidate_names) do
		if not attached_names[name] then
			local ok_cfg, cfg = pcall(function()
				return vim.lsp.config[name]
			end)
			table.insert(entries, {
				name = name,
				status = "available",
				config = (ok_cfg and cfg) or nil,
				is_lsp = ok_cfg and cfg ~= nil,
			})
		end
	end

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 2 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		local icon, hl
		if entry.value.status == "attached" then
			icon, hl = "●", "TelescopeLspAttached"
		else
			icon, hl = "○", "TelescopeLspAvailable"
		end
		return displayer({
			{ icon, hl },
			{ entry.value.name, hl },
		})
	end

	pickers
		.new({}, {
			prompt_title = "LSP Status (buffer: " .. (filetype ~= "" and filetype or "none") .. ")",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry,
						display = make_display,
						ordinal = entry.name .. " " .. entry.status,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = previewers.new_buffer_previewer({
				title = "LSP Details",
				define_preview = function(self, entry)
					local e = entry.value
					local lines = { e.name, "" }
					if e.status == "attached" then
						local c = e.client
						table.insert(lines, "status: attached")
						table.insert(lines, "id: " .. c.id)
						table.insert(lines, "root_dir: " .. (c.root_dir or "n/a"))
						table.insert(lines, "cmd: " .. table.concat(
							type(c.config.cmd) == "table" and c.config.cmd or { tostring(c.config.cmd) },
							" "
						))
						table.insert(lines, "filetypes: " .. table.concat(c.config.filetypes or {}, ", "))
						local attached_bufs = {}
						for buf, _ in pairs(c.attached_buffers or {}) do
							table.insert(attached_bufs, vim.api.nvim_buf_get_name(buf))
						end
						table.insert(lines, "attached buffers:")
						vim.list_extend(lines, #attached_bufs > 0 and attached_bufs or { "  (none)" })
					elseif e.is_lsp then
						table.insert(lines, "status: installed, not attached")
						local cfg = e.config or {}
						table.insert(lines, "cmd: " .. table.concat(
							type(cfg.cmd) == "table" and cfg.cmd or { tostring(cfg.cmd) },
							" "
						))
						table.insert(lines, "filetypes: " .. table.concat(cfg.filetypes or {}, ", "))
					else
						table.insert(lines, "status: installed (Mason tool)")
						table.insert(lines, "not a language server (formatter/linter/DAP/etc.)")
					end
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
				end,
			}),
		})
		:find()
end, { desc = "LSP status (Telescope)" })
