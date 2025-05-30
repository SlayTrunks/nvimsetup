return {
  -- Telescope for fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false, -- Load eagerly to ensure keybindings work
  },

  -- Rose-Pine colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
    lazy = false, -- Load eagerly since it's your colorscheme
  },

  -- Treesitter for better syntax highlighting
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-treesitter/playground' },

  -- Utility plugins
  {
    'theprimeagen/harpoon',
    lazy = false, -- Load eagerly to ensure keybindings work
  },
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

      -- Configure diagnostics with improved wrapped virtual text
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 4,
          format = function(diagnostic)
            -- Wrap long messages to fit the screen
            local message = diagnostic.message
            local win_width = vim.api.nvim_win_get_width(0)
            local max_width = math.max(40, math.min(win_width - 10, 80)) -- Minimum 40 chars, cap at 80 or window width - 10
            local wrapped = {}
            local line = ""
            for word in message:gmatch("[^%s]+") do
              local test_line = line .. (line == "" and "" or " ") .. word
              if vim.fn.strdisplaywidth(test_line) > max_width then
                if line ~= "" then
                  table.insert(wrapped, line)
                end
                line = word
              else
                line = test_line
              end
            end
            if line ~= "" then
              table.insert(wrapped, line)
            end
            return table.concat(wrapped, "\n")
          end,
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
        completion = {
          autocomplete = false, -- Manual completion trigger
        },
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
          { name = 'nvim_lsp', priority = 1000 }, -- Prioritize LSP for attributes like className
          { name = 'buffer', priority = 800 },
          { name = 'luasnip', priority = 500, keyword_pattern = [[\<(div|span|button|input|form|section|article|header|footer|nav|aside|main|Fragment)\>]] }, -- React/Next.js elements
          { name = 'nvim_lua', priority = 300 },
          { name = 'path', priority = 200 },
        }),
        sorting = {
          priority_weight = 2.0,
          comparators = {
            cmp.config.compare.priority,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })

      cmp.setup.filetype({'javascriptreact', 'typescriptreact'}, {
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 }, -- Ensure className attribute is prioritized
          { name = 'luasnip', priority = 800, keyword_pattern = [[\<(div|span|button|input|form|section|article|header|footer|nav|aside|main|Fragment)\>]] },
          { name = 'buffer', priority = 600 },
          { name = 'nvim_lua', priority = 400 },
          { name = 'path', priority = 200 },
        }),
      })

      require('lspsaga').setup({
        ui = {
          border = 'rounded',
          title = true,
        },
        hover = {
          max_width = 0.8,
          open_link = 'gx',
          diagnostic = true, -- Still show diagnostics on hover for additional details
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          on_insert = false, -- Disable diagnostics in insert mode
        },
      })

      -- Disable spell checking globally to remove spelling errors in comments
      vim.opt.spell = false

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
                  includeLanguages = {
                    typescriptreact = "html",
                  },
                }
              },
              filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
