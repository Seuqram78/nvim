require("bufferline").setup()
vim.api.nvim_set_keymap('n', '<leader>.', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':bprev<CR>', { noremap = true, silent = true })
