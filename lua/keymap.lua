vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<ESC><ESC>", function()
  vim.cmd("close")
end, { desc = "Close floating window with double Escape" })
vim.keymap.set("n", "<leader>tf", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy Find Files" })
vim.keymap.set("n", "<leader>ts", "<cmd>Telescope live_grep<CR>", { desc = "Fuzzy Search" })
vim.keymap.set("n", "<leader>tr", "<cmd>Telescope buffers<CR>", { desc = "List Buffers" })
vim.keymap.set("n", "<leader>u", "vim.cmd.UndotreeToggle", { desc = "Toggle UndoTree" })
vim.keymap.set("n", "<C-b>", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic" })

vim.keymap.set("n", "<leader>rp", function()
  local python = "python"
  vim.notify("Using python: " .. python)
  vim.cmd("vsplit | terminal " .. python)
end, { desc = "Run current Python file (venv aware)" })

-- Toggle Term shortcuts
require("toggleterm").setup({})

vim.keymap.set("n", "<leader>hh", function()
  require("toggleterm").toggle(0, nil, nil, "float", 'Floating terminal')
end, { desc = "Toggle floating terminal" })

local dap = require("dap")

vim.keymap.set("n", "<leader>n", require("dap.ui.widgets").hover, { desc = "DAP Evaluate Expression" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue debugging" })
vim.keymap.set("n", "<F6>", dap.terminate, { desc = "Terminate Session" })
vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })

local dapui = require("dapui")
vim.keymap.set("n", "<leader>dd", dapui.open, { desc = "Open Debug Window" })
vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "Close Debug Window" })
