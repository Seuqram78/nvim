-- Default settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.notify = require("notify")

--Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

--UI
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.scrolloff = 20
vim.o.sidescrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true

-- Telescope
local ok, telescope = pcall(require, "telescope")
if ok then
  telescope.setup({
    defaults = {
      file_ignore_patterns = { "node_modules", ".git/" }
    },
    pickers = {
      find_files = {
        hidden = true,    --Show hidden files (dotfiles)
        no_ignore = true, -- Don't respect .gitignore
        follow = true,    -- Follow symlinks
      },
    },
  })
end

require("gruvbox").setup({ contrast = "soft" })
vim.cmd.colorscheme = ("gruvbox")

-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "ruff" }
})

-- LSP lua Config
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' }, -- Avoid 'undefined global vim' warnings
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    }
  }
}

vim.lsp.config("ruff", {
  init_options = {
    settings = {}
  }
})
vim.lsp.enable("ruff")

-- autocomplete
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(), --Trigger completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = { name = { "nvim_lsp" } }
})

-- Conform to autoformat
local function get_lsp_fallback(bufnr)
  local always_use_lsp = not vim.bo[bufnr].filetype:match("^typescript")
  return always_use_lsp and "always" or true
end

require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format" },
  },
  format_on_save = function(bufnr)
    return {
      lsp_fallback = get_lsp_fallback(bufnr),
      timeout_ms = 10000
    }
  end
})

-- Treesitter
require("nvim-treesitter.configs").setup({
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_instal = true,

  highlight = { enable = true }
})

require("lsp_signature").setup({
  timer_interval = 10
})
