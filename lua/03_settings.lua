require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

require("mini.files").setup()

require("lualine").setup({
  sections = {
    lualine_c = { "filename", "lsp_status" },
  },
})

require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry"
  }
})

-- Harpoon
require("harpoon"):setup()

-- Telescope
local ok, telescope = pcall(require, "telescope")
local actions = require("telescope.actions")
if ok then
  telescope.setup({
    defaults = {
      file_ignore_patterns = { "node_modules", ".git/" },
      mappings = {
        i = {
          ["<ESC>"] = actions.close,
        },
      },
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

-- Conform
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = {
      -- To fix auto-fixable lint errors.
      "ruff_fix",
      -- To run the Ruff formatter.
      "ruff_format",
      -- To organize the imports.
      "ruff_organize_imports",
    },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    html = { "prettier" },
    cs = { "lsp" },
    kdl = { "kdlfmt" },
  },
  formatters = {
    prettier = {
      command = "prettier",
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
    },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 3000,
    lsp_format = "fallback",
  },
})

-- DAP
require("dapui").setup({
  layout = {
    {
      elements = {
        { id = "scopes",      size = 0.33 },
        { id = "breakpoints", size = 0.33 },
        { id = "stacks",      size = 0.33 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = { { id = "console", size = 1.0 } },
      size = 15,
      position = "bottom",
    },
  },
})
local dap = require("dap")

dap.adapters.python = {
  type = "executable",
  command = "python",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}", -- This means: run current file
    pythonPath = function()
      return "python"    -- Or set your venv path here
    end,
  },
}

dap.adapters.coreclr = {
  type = "executable",
  command = "/opt/netcoredbg/netcoredbg",
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll")
    end,
  },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      -- Build the project (assumes .csproj is in current working directory)
      local cwd = vim.fn.getcwd()
      vim.fn.system("dotnet build " .. cwd)
      -- Find the DLL (assumes project name matches directory name)
      local project_name = vim.fn.fnamemodify(cwd, ":t")
      local glob = cwd .. "/bin/Debug/net*/" .. project_name .. ".dll"
      local dlls = vim.fn.glob(glob, 0, 1)
      if #dlls > 0 then
        return dlls[1]
      else
        -- glob = cwd .. 'App/bin/Debug/net*/' .. project_name .. '.dll'
        glob = cwd .. "/App/bin/Debug/net*/App.dll"
        dlls = vim.fn.glob(glob, 0, 1)
        if #dlls > 0 then
          return dlls[1]
        else
          -- Prompt if not found
          return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/net9.0/", "file")
        end
      end
    end,
  },
}

require("nvim-dap-virtual-text").setup({
  -- optional settings
  commented = true, -- show virtual text as comments
})

-- CMP
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

vim.lsp.config("emmylua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,       --gives vim.* types/completion
          vim.fn.stdpath("config"), -- your nvim config
        },
      },
    },
  },
})
