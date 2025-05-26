local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>aa', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>ar', builtin.git_files, { desc = 'Find in a git repository' })
vim.keymap.set('n', '<leader>as', builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set('n', '<leader>tla', ':Telescope diagnostics<CR>')
vim.api.nvim_set_keymap('n', '<leader>tll', '', {
    noremap = true,
    silent = true,
    callback = function()
        require('telescope.builtin').diagnostics({ bufnr = 0 })
    end
})
