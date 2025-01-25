local luasnip = require("luasnip")

-- Define snippets
luasnip.snippets = {
  html = {
    -- Add your html snippets here
  },
  tailwindcss = {
    luasnip.snippet("twc", { luasnip.text_node('class="') }),  -- A simple example snippet
    -- Add more Tailwind CSS snippets as needed
  },
}

-- Extend html and tailwindcss snippets to other file types
luasnip.snippets.javascript = vim.tbl_deep_extend("force", {}, luasnip.snippets.html, luasnip.snippets.tailwindcss)
luasnip.snippets.javascriptreact = vim.tbl_deep_extend("force", {}, luasnip.snippets.html, luasnip.snippets.tailwindcss)
luasnip.snippets.typescriptreact = vim.tbl_deep_extend("force", {}, luasnip.snippets.html, luasnip.snippets.tailwindcss)

-- Load snippets from VSCode
require("luasnip/loaders/from_vscode").lazy_load()

-- Extend file types with html and tailwindcss snippets
require('luasnip').filetype_extend("javascriptreact", { "html", "tailwindcss" })
require('luasnip').filetype_extend("typescriptreact", { "html", "tailwindcss" })
