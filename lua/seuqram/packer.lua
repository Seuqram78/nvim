-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({ 'rose-pine/neovim', as = 'rose-pine' })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use('ThePrimeagen/harpoon')

    use('tpope/vim-fugitive')

    use('mbbill/undotree')

    use('neovim/nvim-lspconfig', { tag = 'v1.8.0', pin = true })

    use('hrsh7th/cmp-nvim-lsp')

    use('hrsh7th/nvim-cmp')

    use('mason-org/mason.nvim', { tag = 'v1.11.0', pin = true })

    use('mason-org/mason-lspconfig.nvim', { tag = 'v1.32.0', pin = true })

    use({
        "kdheepak/lazygit.nvim",
    })

    use("akinsho/toggleterm.nvim", { tag = '*' })

    use(
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { requires = "williamboman/mason.nvim" }
    )

    use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' }
end)
