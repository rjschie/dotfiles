-- Bootload Packer
-- Hint: string concat is done with `..`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Reload configurations if we modify this file
-- Hint: `<afile>` is replaced with the filename of the buffer manipulated
-- vim.cmd([[
--     augroup packer_user_config
--         autocmd!
--         autocmd BufWritePost plugins.lua Lazy install
--     augroup end
-- ]])

require('lazy').setup("plugins")

