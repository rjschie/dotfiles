return {
  'hardhackerlabs/theme-vim',
  name = 'hardhacker',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'hardhacker'
    vim.o.termguicolors = true
    vim.cmd.hi 'Comment gui=none'
  end,
}
