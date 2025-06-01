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
-- 12345
  {
    'folke/flash.nvim',
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = true,
        },
        char = {
          enabled = true,
          keys = { "f", "F", "t", "T", ";", "," },
        },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
    })
     -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Custom terminal functions
      local Terminal  = require('toggleterm.terminal').Terminal
      
      -- Lazygit terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      -- Node terminal
      local node = Terminal:new({ cmd = "node", hidden = true })

      function _NODE_TOGGLE()
        node:toggle()
      end

      -- Python terminal
      local python = Terminal:new({ cmd = "python", hidden = true })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      -- Keymaps for custom terminals
      vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true})
      vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", {noremap = true, silent = true})
      vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", {noremap = true, silent = true})
    end,
  },
  -- Utility plugins
  {
    'theprimeagen/harpoon',
    branch = "harpoon2",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED: Setup harpoon
      harpoon:setup()

      -- Keymaps for Harpoon v2
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
    end
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
      { 'L3MON4D3/LuaSnip', build = "make install_jsregexp" },
      { 'rafamadriz/friendly-snippets' }, -- Re-enabled but will be filtered
      
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
      local luasnip = require('luasnip')
      
      -- Configure LuaSnip to only load useful snippets
      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = false, -- Disable auto snippets
        ext_opts = nil,
      })
      
      -- Load friendly-snippets but we'll filter them
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Load custom snippets if available
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "./snippets" }
      })
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ 
            select = true, -- Auto-select first item
            behavior = cmp.ConfirmBehavior.Replace 
          }),
          ['<C-y>'] = cmp.mapping(function()
            -- Custom Emmet-like expansion for JSX/HTML
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = string.sub(line, 1, col)
            local after_cursor = string.sub(line, col + 1)
            
            -- Pattern: element.class1.class2#id or element#id.class1.class2
            local pattern = "([a-zA-Z][a-zA-Z0-9]*)([.#][a-zA-Z0-9._#-]+)"
            local element, modifiers = string.match(before_cursor, pattern .. "$")
            
            -- Also match simple element names without modifiers
            if not element then
              element = string.match(before_cursor, "([a-zA-Z][a-zA-Z0-9]*)$")
              modifiers = ""
            end
            
            if element then
              local filetype = vim.bo.filetype
              local is_jsx = filetype == "javascriptreact" or filetype == "typescriptreact"
              local class_attr = is_jsx and "className" or "class"
              
              -- Parse classes and ids
              local classes = {}
              local id = nil
              
              if modifiers and modifiers ~= "" then
                for modifier in string.gmatch(modifiers, "[.#][^.#]+") do
                  if string.sub(modifier, 1, 1) == "." then
                    table.insert(classes, string.sub(modifier, 2))
                  elseif string.sub(modifier, 1, 1) == "#" then
                    id = string.sub(modifier, 2)
                  end
                end
              end
              
              -- Elements that should be multi-line (block elements)
              local multiline_elements = {
                "div", "section", "article", "header", "footer", "nav", "main", "aside",
                "h1", "h2", "h3", "h4", "h5", "h6", "p", "blockquote", "pre",
                "ul", "ol", "li", "dl", "dt", "dd", "form", "fieldset", "table",
                "thead", "tbody", "tfoot", "tr", "th", "td", "canvas", "video", "audio"
              }
              
              local is_multiline = false
              for _, multi_elem in ipairs(multiline_elements) do
                if element == multi_elem then
                  is_multiline = true
                  break
                end
              end
              
              -- Build the opening tag
              local opening_tag = "<" .. element
              
              if id then
                opening_tag = opening_tag .. ' id="' .. id .. '"'
              end
              
              if #classes > 0 then
                opening_tag = opening_tag .. ' ' .. class_attr .. '="' .. table.concat(classes, " ") .. '"'
              end
              
              opening_tag = opening_tag .. ">"
              
              -- Build the closing tag
              local closing_tag = "</" .. element .. ">"
              
              -- Calculate replacement position
              local match_length = string.len(element)
              if modifiers and modifiers ~= "" then
                match_length = match_length + string.len(modifiers)
              end
              local start_col = col - match_length
              
              if is_multiline then
                -- Multi-line expansion: opening tag, empty line, closing tag
                local current_row = vim.api.nvim_win_get_cursor(0)[1]
                local indent = string.match(before_cursor, "^(%s*)")
                
                -- Create the lines
                local new_lines = {
                  string.sub(before_cursor, 1, start_col) .. opening_tag .. after_cursor,
                  indent .. "",  -- Empty line with proper indentation
                  indent .. closing_tag
                }
                
                -- Replace current line and insert new lines
                vim.api.nvim_buf_set_lines(0, current_row - 1, current_row, false, new_lines)
                
                -- Position cursor on the empty line
                vim.api.nvim_win_set_cursor(0, {current_row + 1, string.len(indent)})
              else
                -- Inline expansion: <element></element>
                local replacement = opening_tag .. closing_tag
                local new_line = string.sub(before_cursor, 1, start_col) .. replacement .. after_cursor
                
                vim.api.nvim_set_current_line(new_line)
                
                -- Position cursor between the tags
                local cursor_pos = start_col + string.len(opening_tag)
                vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(0)[1], cursor_pos})
              end
            else
              -- Fallback to regular confirm if no pattern matches
              if cmp.visible() then
                cmp.confirm({ select = true })
              end
            end
          end),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { 
            name = 'nvim_lsp', 
            priority = 1000,
            max_item_count = 20,
            entry_filter = function(entry, ctx)
              -- Filter out less useful LSP items
              local kind = entry:get_kind()
              local line = ctx.cursor_line
              local col = ctx.cursor.col
              
              -- Prioritize specific types based on context
              if kind == cmp.lsp.CompletionItemKind.Snippet then
                return false -- Filter out LSP snippets in favor of luasnip
              end
              
              -- Prioritize variables, functions, methods over others
              local high_priority_kinds = {
                cmp.lsp.CompletionItemKind.Variable,
                cmp.lsp.CompletionItemKind.Function,
                cmp.lsp.CompletionItemKind.Method,
                cmp.lsp.CompletionItemKind.Property,
                cmp.lsp.CompletionItemKind.Field,
                cmp.lsp.CompletionItemKind.Class,
                cmp.lsp.CompletionItemKind.Interface,
                cmp.lsp.CompletionItemKind.Module,
                cmp.lsp.CompletionItemKind.Constructor,
              }
              
              return true
            end
          },
          { 
            name = 'luasnip', 
            priority = 800,
            max_item_count = 15,
            entry_filter = function(entry, ctx)
              local filetype = vim.bo.filetype
              
              -- Get the completion item text
              local item_text = entry.completion_item.label or ""
              local trigger = item_text:lower()
              
              -- Jibberish patterns to filter out
              local jibberish_patterns = {
                "lorem", "ipsum", "dolor", "sit", "amet",
                "classn$", -- Ends with classn (like the annoying classn snippet)
                "^.$", -- Single character snippets
                "test123", "sample", "placeholder", "dummy"
              }
              
              if filetype == "javascript" or filetype == "javascriptreact" or 
                 filetype == "typescript" or filetype == "typescriptreact" then
                
                -- First check if it's jibberish and filter it out
                for _, jibberish in ipairs(jibberish_patterns) do
                  if string.match(trigger, jibberish) then
                    return false
                  end
                end
                
                -- Allow useful snippets (this is a more permissive approach)
                local useful_js_snippets = {
                  -- JavaScript/TypeScript basics
                  "const", "let", "var", "function", "arrow", "import", "export",
                  "class", "constructor", "async", "await", "promise", "try",
                  "if", "for", "while", "switch", "map", "filter", "reduce",
                  
                  -- React Hooks
                  "usestate", "useeffect", "usecallback", "usememo", "useref",
                  "usecontext", "usereducer", "uselayouteffect",
                  
                  -- JSX/React Components  
                  "div", "span", "p", "h1", "h2", "h3", "h4", "h5", "h6",
                  "button", "input", "form", "img", "a", "ul", "ol", "li",
                  "nav", "header", "footer", "main", "section", "article",
                  "component", "rfc", "rfce", "rafce", "rce", "ffc",
                  
                  -- React specific
                  "props", "state", "render", "jsx", "tsx", "fragment",
                  "classname", "onclick", "onchange", "onsubmit"
                }
                
                -- Check if it matches useful patterns
                for _, useful in ipairs(useful_js_snippets) do
                  if string.find(trigger, useful) then
                    return true
                  end
                end
                
                -- Allow short snippets that might be JSX elements (but not single chars)
                if string.len(trigger) >= 2 and string.len(trigger) <= 6 and 
                   string.match(trigger, "^[a-z][a-z0-9]*$") then
                  return true
                end
                
                -- Default: allow if not explicitly jibberish
                return true
              end
              
              return true -- Allow all snippets for other filetypes
            end
          },
          { 
            name = 'buffer', 
            priority = 300,
            max_item_count = 5,
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          { 
            name = 'path', 
            priority = 200,
            max_item_count = 5
          },
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        formatting = {
          format = function(entry, vim_item)
            -- Simple formatting without icons or fancy styling
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            
            return vim_item
          end
        },
        window = {
          completion = {
            border = "none",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          },
          documentation = {
            border = "none",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          },
        },
        experimental = {
          ghost_text = false, -- Disable ghost text to reduce clutter
        },
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
          'ts_ls', -- TypeScript/JavaScript LSP (replaces tsserver)
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
          
          -- TypeScript/JavaScript LSP configuration
          ts_ls = function()
            require('lspconfig').ts_ls.setup({
              settings = {
                typescript = {
                  preferences = {
                    includeCompletionsForModuleExports = true,
                    includeCompletionsForImportStatements = true,
                  },
                },
                javascript = {
                  preferences = {
                    includeCompletionsForModuleExports = true,
                    includeCompletionsForImportStatements = true,
                  },
                },
              },
              init_options = {
                preferences = {
                  disableSuggestions = false,
                },
              },
            })
          end,
          
          -- Emmet configuration for HTML/JSX
          emmet_ls = function()
            require('lspconfig').emmet_ls.setup({
              filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
              init_options = {
                html = {
                  options = {
                    ["bem.enabled"] = true,
                  },
                },
              }
            })
          end,
          
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
                  classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
                  lint = {
                    cssConflict = "warning",
                    invalidApply = "error",
                    invalidConfigPath = "error",
                    invalidScreen = "error",
                    invalidTailwindDirective = "error",
                    invalidVariant = "error",
                    recommendedVariantOrder = "warning"
                  },
                }
              },
              filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
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
      
      -- Add custom Emmet-like keybinding for all relevant filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        callback = function()
          vim.keymap.set("i", "<C-e>", function()
            -- Custom Emmet-like expansion for JSX/HTML
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = string.sub(line, 1, col)
            local after_cursor = string.sub(line, col + 1)
            
            -- Pattern: element.class1.class2#id or element#id.class1.class2
            local pattern = "([a-zA-Z][a-zA-Z0-9]*)([.#][a-zA-Z0-9._#-]+)"
            local element, modifiers = string.match(before_cursor, pattern .. "$")
            
            -- Also match simple element names without modifiers
            if not element then
              element = string.match(before_cursor, "([a-zA-Z][a-zA-Z0-9]*)$")
              modifiers = ""
            end
            
            if element then
              local filetype = vim.bo.filetype
              local is_jsx = filetype == "javascriptreact" or filetype == "typescriptreact"
              local class_attr = is_jsx and "className" or "class"
              
              -- Parse classes and ids
              local classes = {}
              local id = nil
              
              if modifiers and modifiers ~= "" then
                for modifier in string.gmatch(modifiers, "[.#][^.#]+") do
                  if string.sub(modifier, 1, 1) == "." then
                    table.insert(classes, string.sub(modifier, 2))
                  elseif string.sub(modifier, 1, 1) == "#" then
                    id = string.sub(modifier, 2)
                  end
                end
              end
              
              -- Elements that should be multi-line (block elements)
              local multiline_elements = {
                "div", "section", "article", "header", "footer", "nav", "main", "aside",
                "h1", "h2", "h3", "h4", "h5", "h6", "p", "blockquote", "pre",
                "ul", "ol", "li", "dl", "dt", "dd", "form", "fieldset", "table",
                "thead", "tbody", "tfoot", "tr", "th", "td", "canvas", "video", "audio"
              }
              
              local is_multiline = false
              for _, multi_elem in ipairs(multiline_elements) do
                if element == multi_elem then
                  is_multiline = true
                  break
                end
              end
              
              -- Build the opening tag
              local opening_tag = "<" .. element
              
              if id then
                opening_tag = opening_tag .. ' id="' .. id .. '"'
              end
              
              if #classes > 0 then
                opening_tag = opening_tag .. ' ' .. class_attr .. '="' .. table.concat(classes, " ") .. '"'
              end
              
              opening_tag = opening_tag .. ">"
              
              -- Build the closing tag
              local closing_tag = "</" .. element .. ">"
              
              -- Calculate replacement position
              local match_length = string.len(element)
              if modifiers and modifiers ~= "" then
                match_length = match_length + string.len(modifiers)
              end
              local start_col = col - match_length
              
              if is_multiline then
                -- Multi-line expansion: opening tag, empty line, closing tag
                local current_row = vim.api.nvim_win_get_cursor(0)[1]
                local indent = string.match(before_cursor, "^(%s*)")
                
                -- Create the lines
                local new_lines = {
                  string.sub(before_cursor, 1, start_col) .. opening_tag .. after_cursor,
                  indent .. "",  -- Empty line with proper indentation
                  indent .. closing_tag
                }
                
                -- Replace current line and insert new lines
                vim.api.nvim_buf_set_lines(0, current_row - 1, current_row, false, new_lines)
                
                -- Position cursor on the empty line
                vim.api.nvim_win_set_cursor(0, {current_row + 1, string.len(indent)})
              else
                -- Inline expansion: <element></element>
                local replacement = opening_tag .. closing_tag
                local new_line = string.sub(before_cursor, 1, start_col) .. replacement .. after_cursor
                
                vim.api.nvim_set_current_line(new_line)
                
                -- Position cursor between the tags
                local cursor_pos = start_col + string.len(opening_tag)
                vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(0)[1], cursor_pos})
              end
            end
          end, { buffer = true, desc = "Emmet-like expansion" })
        end,
      })
    end
  },

  -- Add lspsaga.nvim for enhanced LSP UI
  { 'nvimdev/lspsaga.nvim' },
}
