return {
  -- Telescope for fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Rose-Pine colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  },

  -- Treesitter for better syntax highlighting
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-treesitter/playground' },

  -- Utility plugins
  { 'theprimeagen/harpoon' },
  { 'itmammoth/doorboy.vim' },
  { 'tpope/vim-fugitive' },

  -- LSP and Autocompletion plugins
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
      
      -- TailwindCSS Snippets and Highlighting
      { 'princejoogie/tailwind-highlight.nvim' },
      { 'onsails/lspkind-nvim' },
    },
    config = function()
      require('mason').setup()
      
      local lsp_zero = require('lsp-zero')
      lsp_zero.preset('recommended')

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 4,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      lsp_zero.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() require('lspsaga.hover'):render_hover_doc() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end)

      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
        })
      })

      require('lspsaga').setup({
        ui = {
          border = 'rounded',
          title = true,
        },
        hover = {
          max_width = 0.8,
          open_link = 'gx',
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
        },
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
          'eslint',
          'html',
          'cssls',
          'emmet_ls',
          'vls',
          'rust_analyzer',
          'graphql',
          'prismals',
          'tailwindcss',
        },
        handlers = {
          lsp_zero.default_setup,
          tailwindcss = function()
            require('lspconfig').tailwindcss.setup({
              on_attach = function(client, bufnr)
                require('tailwind-highlight').setup(client, bufnr, {
                  single_column = false,
                  mode = 'background',
                  debounce = 200,
                })
              end,
              settings = {
                tailwindCSS = {
                  validate = true,
                }
              }
            })
          end,
          rust_analyzer = function()
            require('lspconfig').rust_analyzer.setup({
              settings = {
                ['rust-analyzer'] = {
                  inlayHints = {
                    enable = true,
                    typeHints = true,
                    parameterHints = true,
                    chainingHints = true,
                  },
                  diagnostics = {
                    enable = true,
                  },
                  hover = {
                    actions = {
                      enable = true,
                    },
                    memoryLayout = {
                      enable = true,
                    },
                  },
                }
              }
            })
          end,
        }
      })

      lsp_zero.setup()
    end
  },

  -- Add lspsaga.nvim for enhanced LSP UI
  { 'nvimdev/lspsaga.nvim' },
}
