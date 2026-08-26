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
vim.api.nvim_set_hl(0, "TelescopeLspStarting", { link = "DiagnosticWarn", default = true })

local lsp_pickers = require("telescope.pickers")
local lsp_finders = require("telescope.finders")
local lsp_telescope_conf = require("telescope.config").values
local lsp_previewers = require("telescope.previewers")
local lsp_entry_display = require("telescope.pickers.entry_display")

-- Capture warnings/errors LSP servers report via window/logMessage and
-- window/showMessage, keyed by client name, so the picker below can flag
-- servers that reported something wrong even when nothing was ever shown
-- on screen (window/logMessage only ever reaches the log file by default,
-- e.g. bashls quietly disabling shellcheck-based linting when the
-- `shellcheck` binary isn't on PATH).
local lsp_feedback = {}
local MAX_FEEDBACK_PER_CLIENT = 5

-- Live-refresh state: while the picker below is open, LspAttach/LspDetach
-- (and new feedback) rebuild and push a fresh finder into it instead of
-- requiring the user to close and reopen it to see updated status.
local active_lsp_picker = nil
local active_lsp_picker_bufnr = nil
local active_lsp_picker_augroup = nil
local active_lsp_picker_timer = nil

local function build_lsp_entries(bufnr)
	-- vim.lsp.get_clients() silently excludes any client still mid
	-- `initialize` handshake (client.initialized == false) unless
	-- `_uninitialized = true` is passed. That's exactly the "attaching"
	-- window we want to show, so fetch everything and classify by hand.
	local all_clients = vim.lsp.get_clients({ _uninitialized = true })

	local attached_names = {}
	local entries = {}
	for _, client in ipairs(all_clients) do
		if client.initialized and client.attached_buffers[bufnr] then
			attached_names[client.name] = true
			table.insert(entries, {
				name = client.name,
				status = "attached",
				client = client,
			})
		end
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

	-- Clients that are running (process spawned, not stopped) and apply to
	-- THIS buffer's filetype but aren't attached+initialized yet: still mid
	-- `initialize` handshake. Shown as "starting" rather than lumped in with
	-- servers that were never started, or ones running only for other buffers.
	local filetype = vim.bo[bufnr].filetype
	local starting_names = {}
	for _, client in ipairs(all_clients) do
		local applies = vim.tbl_contains(client.config.filetypes or {}, filetype)
		local already_attached = client.initialized and client.attached_buffers[bufnr]
		if applies and not already_attached and not client:is_stopped() then
			starting_names[client.name] = true
		end
	end

	for name in pairs(candidate_names) do
		if not attached_names[name] then
			local ok_cfg, cfg = pcall(function()
				return vim.lsp.config[name]
			end)
			table.insert(entries, {
				name = name,
				status = starting_names[name] and "starting" or "available",
				config = (ok_cfg and cfg) or nil,
				is_lsp = ok_cfg and cfg ~= nil,
			})
			starting_names[name] = nil
		end
	end
	-- Any starting client not covered by the candidate list above (e.g.
	-- manually started, or under a name Mason doesn't know about).
	for name in pairs(starting_names) do
		table.insert(entries, { name = name, status = "starting" })
	end

	return entries
end

local lsp_displayer = lsp_entry_display.create({
	separator = " ",
	items = {
		{ width = 2 },
		{ width = 26 },
		{ remaining = true },
	},
})

local function make_lsp_display(entry)
	local icon, hl
	if entry.value.status == "attached" then
		icon, hl = "●", "TelescopeLspAttached"
	elseif entry.value.status == "starting" then
		icon, hl = "◐", "TelescopeLspStarting"
	else
		icon, hl = "○", "TelescopeLspAvailable"
	end

	local feedback = lsp_feedback[entry.value.name]
	local warning = { "", hl }
	if feedback and #feedback > 0 then
		local has_error = false
		for _, f in ipairs(feedback) do
			has_error = has_error or f.level == "ERROR"
		end
		warning = has_error and { "✗ error", "DiagnosticError" } or { "⚠ warning", "DiagnosticWarn" }
	end

	return lsp_displayer({
		{ icon, hl },
		{ entry.value.name, hl },
		warning,
	})
end

local function lsp_entry_maker(entry)
	return {
		value = entry,
		display = make_lsp_display,
		ordinal = entry.name .. " " .. entry.status,
	}
end

local function lsp_define_preview(self, entry)
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
	elseif e.status == "starting" then
		table.insert(lines, "status: starting (running, not yet attached to this buffer)")
		local cfg = e.config or {}
		if cfg.cmd then
			table.insert(lines, "cmd: " .. table.concat(
				type(cfg.cmd) == "table" and cfg.cmd or { tostring(cfg.cmd) },
				" "
			))
		end
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

	local feedback = lsp_feedback[e.name]
	if feedback and #feedback > 0 then
		table.insert(lines, "")
		table.insert(lines, "recent messages:")
		for _, f in ipairs(feedback) do
			table.insert(lines, string.format("  [%s %s] %s", f.time, f.level, f.message))
		end
	end

	vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
end

local function refresh_active_lsp_picker()
	if not active_lsp_picker or active_lsp_picker.closed then
		if active_lsp_picker_augroup then
			pcall(vim.api.nvim_del_augroup_by_id, active_lsp_picker_augroup)
		end
		if active_lsp_picker_timer then
			active_lsp_picker_timer:stop()
			active_lsp_picker_timer:close()
		end
		active_lsp_picker, active_lsp_picker_bufnr, active_lsp_picker_augroup, active_lsp_picker_timer =
			nil, nil, nil, nil
		return
	end
	active_lsp_picker:refresh(
		lsp_finders.new_table({
			results = build_lsp_entries(active_lsp_picker_bufnr),
			entry_maker = lsp_entry_maker,
		}),
		{ reset_prompt = false }
	)
end

local function record_lsp_feedback(client_id, level, message)
	local client = vim.lsp.get_client_by_id(client_id)
	local name = client and client.name or ("id=" .. tostring(client_id))
	local list = lsp_feedback[name]
	if not list then
		list = {}
		lsp_feedback[name] = list
	end
	table.insert(list, { level = level, message = message, time = os.date("%H:%M:%S") })
	if #list > MAX_FEEDBACK_PER_CLIENT then
		table.remove(list, 1)
	end
	vim.schedule(refresh_active_lsp_picker)
end

for _, method in ipairs({ "window/logMessage", "window/showMessage" }) do
	local original = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, params, ctx, config)
		if params.type == vim.lsp.protocol.MessageType.Error then
			record_lsp_feedback(ctx.client_id, "ERROR", params.message)
		elseif params.type == vim.lsp.protocol.MessageType.Warning then
			record_lsp_feedback(ctx.client_id, "WARN", params.message)
		end
		return original(err, params, ctx, config)
	end
end

vim.keymap.set("n", "<leader>lsp", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype

	local picker = lsp_pickers.new({}, {
		prompt_title = "LSP Status (buffer: " .. (filetype ~= "" and filetype or "none") .. ")",
		finder = lsp_finders.new_table({
			results = build_lsp_entries(bufnr),
			entry_maker = lsp_entry_maker,
		}),
		sorter = lsp_telescope_conf.generic_sorter({}),
		previewer = lsp_previewers.new_buffer_previewer({
			title = "LSP Details",
			define_preview = lsp_define_preview,
		}),
	})

	active_lsp_picker = picker
	active_lsp_picker_bufnr = bufnr
	active_lsp_picker_augroup = vim.api.nvim_create_augroup("LspStatusPickerLive", { clear = true })
	vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
		group = active_lsp_picker_augroup,
		callback = function()
			vim.schedule(refresh_active_lsp_picker)
		end,
	})

	-- LspAttach only fires once a client finishes attaching, missing the
	-- window where it has just spawned and is still initializing (exactly
	-- the "attaching" signal we want visible). Poll on a short interval too
	-- so that transition shows up even without a dedicated event for it.
	active_lsp_picker_timer = vim.uv.new_timer()
	active_lsp_picker_timer:start(250, 250, vim.schedule_wrap(refresh_active_lsp_picker))

	picker:find()
end, { desc = "LSP status (Telescope)" })
