local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>aa', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>ar', builtin.git_files, { desc = 'Find in a git repository' })
vim.keymap.set('n', '<leader>as', function() 
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)


