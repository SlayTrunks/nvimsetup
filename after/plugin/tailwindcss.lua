return {
  {
    "neovim/nvim-lspconfig",  -- Plugin to manage LSP configurations
    opts = {
      servers = {
        -- Tailwind CSS LSP Configuration
        tailwindcss = {
          on_attach = function(client, bufnr)
            -- Custom functionality to run when the LSP server attaches to a buffer
            -- Add key mappings, etc., if needed
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
          end,
          settings = {
            -- Example: any specific settings for the Tailwind CSS LSP
            tailwindCSS = {
              validate = true,
            }
          }
        },
      },
    },
  },
}

