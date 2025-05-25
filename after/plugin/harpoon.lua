
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu, { desc = "Harpoon: Toggle quick menu" })
vim.keymap.set("n", "<leader>z", function() ui.nav_file(1) end, { desc = "Harpoon: Navigate to file 1" })
vim.keymap.set("n", "<leader>x", function() ui.nav_file(2) end, { desc = "Harpoon: Navigate to file 2" })
vim.keymap.set("n", "<leader>c", function() ui.nav_file(3) end, { desc = "Harpoon: Navigate to file 3" })
vim.keymap.set("n", "<leader>d", function() ui.nav_file(4) end, { desc = "Harpoon: Navigate to file 4" })






