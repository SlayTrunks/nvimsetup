-- Check if telescope is available
local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  vim.notify("Telescope not found!")
  return
end

local builtin = require('telescope.builtin')

-- Basic telescope setup (optional but recommended)
telescope.setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "dist/",
      "build/"
    },
  },
})

-- Key mappings
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope git files' })

vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = 'Telescope grep string' })

-- Additional useful mappings
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Telescope live grep' })

-- Debug: Print when this file loads
