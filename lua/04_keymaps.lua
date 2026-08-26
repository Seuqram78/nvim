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

vim.keymap.set("n", "<leader>li", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP attached", vim.log.levels.WARN)
	else
		local names = vim.tbl_map(function(c) return c.name end, clients)
		vim.notify("LSP: " .. table.concat(names, ", "), vim.log.levels.INFO)
	end
end, { desc = "Show active LSP clients" })
