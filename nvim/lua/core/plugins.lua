-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Packer can manage itself
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use 'airblade/vim-gitgutter'
    use 'tpope/vim-fugitive'
    use 'mbbill/undotree'
    use 'nvim-tree/nvim-tree.lua'
    use { "folke/which-key.nvim", disable = true } -- bug: somehow hides gd
    use { 
        "kylechui/nvim-surround", 
        tag = "*", 
        config = function() 
            require("nvim-surround").setup({
            })
        end
    }

    use { "catppuccin/nvim",
        disable = true,
        as = "catppuccin",
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    }

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").load_extension "file_browser"
        end
    }

    use {
        "nvim-telescope/telescope-project.nvim",
        requires = { "nvim-telescope/telescope.nvim" },
        config = function()
            require 'telescope'.load_extension('project')
        end
    }

end)