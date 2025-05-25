require("toggleterm").setup()

vim.api.nvim_set_keymap('n', '<leader>tv', ':ToggleTerm size=40 dir=~/Desktop direction=vertical name=desktop<CR>', { noremap = true, silent = true })
