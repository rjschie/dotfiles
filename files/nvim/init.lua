local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Some options need to be set before plugins load; just load all options now
require 'config.options'

require('lazy').setup({ import = 'plugins' }, {
  change_detection = {
    notify = false,
  },
})

require 'config.autocmds'
require 'config.keymaps'
