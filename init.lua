-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
  print('Done.')
end
vim.opt.rtp:prepend(lazypath)

-- Set custom highlight for inlay hints (from previous customization)
vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#eb6f92', italic = true })

require('lazy').setup('insanedai.plugins')
require("insanedai.remap")
require("insanedai.set")
