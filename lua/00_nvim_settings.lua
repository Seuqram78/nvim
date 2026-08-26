-- Default settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

--Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

-- -- --UI
vim.o.termguicolors = true
-- Keep the insert-mode caret visible in terminals and GUI clients.
-- Cursor/lCursor colours are supplied by the active colourscheme.
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci:ver35-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,o:hor50-Cursor/lCursor"
vim.o.signcolumn = "yes"
vim.o.cmdheight = 0
vim.o.cursorline = true
vim.o.scrolloff = 999
vim.o.sidescrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", space = "·", trail = "~", nbsp = "␣" }
