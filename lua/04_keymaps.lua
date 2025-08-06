vim.keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy Find Files" })
vim.keymap.set("n", "<leader>ts", "<cmd>Telescope live_grep<CR>", { desc = "Fuzzy Search" })
vim.keymap.set("n", "<leader>tr", "<cmd>Telescope buffers<CR>", { desc = "List Buffers" })

-- mini files
vim.keymap.set("n", "<leader>pv", function()
	require("mini.files").open()
end)

-- DAP
local dap = require("dap")
vim.keymap.set("n", "<F5>", function()
	dap.continue()
end, { desc = "DAP: Continue" })
vim.keymap.set("n", "<F7>", function()
	dap.step_into()
end, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F8>", function()
	dap.step_over()
end, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F9>", function()
	dap.continue()
end, { desc = "DAP: Resume" })
vim.keymap.set("n", "<leader>bb", function()
	dap.toggle_breakpoint()
end, { desc = "DAP: Toggle Breakpoint" })

-- DAP UI
local dapui = require("dapui")

vim.keymap.set("n", "<leader>dd", function()
	dapui.open()
end, { desc = "DAP UI Open" })
vim.keymap.set("n", "<leader>dc", function()
	dapui.close()
end, { desc = "DAP UI Close" })
