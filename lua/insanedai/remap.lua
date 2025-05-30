-- General keybindings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Telescope keybindings (from after/telescope.lua)
vim.keymap.set('n', '<leader>pf', require('telescope.builtin').find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files, { desc = 'Telescope git files' })
vim.keymap.set('n', '<leader>ps', function()
  require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = 'Telescope grep string' })

-- Harpoon keybindings (from after/harpoon.lua)
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set('n', '<leader>a', mark.add_file, { desc = "Harpoon mark file" })
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = "Harpoon toggle quick menu" })
vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end, { desc = "Harpoon select file 1" })
vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end, { desc = "Harpoon select file 2" })
vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end, { desc = "Harpoon select file 3" })
vim.keymap.set('n', '<C-s>', function() ui.nav_file(4) end, { desc = "Harpoon select file 4" })

-- Fugitive keybinding (from after/fugitive.lua)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Fugitive Git status" })
