vim.g.mapleader = " "
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

require('lazy').setup('insanedai.plugins')
require("insanedai.remap")
require("insanedai.set")
