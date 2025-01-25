local luasnip = require("luasnip")

-- Define snippets
luasnip.snippets = {
  html = {
    -- Add your HTML snippets here
  },
  -- Removed Tailwind CSS snippets
}

-- Extend HTML snippets to other file types
luasnip.snippets.javascript = vim.tbl_deep_extend("force", {}, luasnip.snippets.html)
luasnip.snippets.javascriptreact = vim.tbl_deep_extend("force", {}, luasnip.snippets.html)
luasnip.snippets.typescriptreact = vim.tbl_deep_extend("force", {}, luasnip.snippets.html)

-- Load snippets from VSCode
require("luasnip/loaders/from_vscode").lazy_load()

-- Extend file types with HTML snippets only
require('luasnip').filetype_extend("javascriptreact", { "html" })
require('luasnip').filetype_extend("typescriptreact", { "html" })
