local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local lspconfig = require('lspconfig')
local tw_highlight = require('tailwind-highlight')

-- Initialize lsp-zero
lsp_zero.setup()

-- Mason setup
require('mason').setup()

-- Mason-LSPconfig setup
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
    -- Default LSP Zero handler
    lsp_zero.default_setup,

    -- Custom handler for tailwindcss LSP
    tailwindcss = function()
      local opts = {
        on_attach = function(client, bufnr)
          -- Tailwind CSS highlighting setup
          tw_highlight.setup(client, bufnr, {
            single_column = false,  -- Whether to highlight only the first character
            mode = 'background',    -- Highlight mode, can be 'background' or 'foreground'
            debounce = 200,         -- Delay in ms before updating highlights
          })
        end
      }
      -- Setup the tailwindcss LSP server
      lspconfig.tailwindcss.setup(opts)
    end,
  }
})

-- Setup nvim-cmp with snippet expansion and LSP integration
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)  -- Expand snippets using LuaSnip
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),  -- Trigger completion
    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
  }),
  sources = cmp.config.sources({
    { name = 'luasnip' },  -- Ensure snippets are prioritized
    { name = 'nvim_lsp' },  -- LSP source
    { name = 'nvim_lua' },  -- Lua source
    { name = 'buffer' },  -- Buffer source
  })
})

-- Set up LSP Zero's on_attach function
lsp_zero.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- Key mappings for LSP functions
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)
