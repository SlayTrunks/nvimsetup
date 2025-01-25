-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope for fuzzy finding
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Rose-Pine colorscheme
  use {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  }

  -- Treesitter for better syntax highlighting
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use('nvim-treesitter/playground')

  -- Utility plugins
  use('theprimeagen/harpoon')
  use('itmammoth/doorboy.vim')
  use('tpope/vim-fugitive')

  -- LSP and Autocompletion plugins
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
      
      -- TailwindCSS Snippets and Highlighting
      {"princejoogie/tailwind-highlight.nvim"},  -- Tailwind CSS snippets and highlighting
      {"onsails/lspkind-nvim"},  -- LSP kind for autocompletion
    },
    config = function()
      -- LSP Zero configuration
      local lsp_zero = require('lsp-zero')
      lsp_zero.preset('recommended')

      lsp_zero.setup()

      -- Setup for Tailwind CSS LSP server
      require('mason-lspconfig').setup({
        ensure_installed = { "tailwindcss" }
      })
    end
  }
end)

