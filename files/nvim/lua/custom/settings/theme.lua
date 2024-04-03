return {
  {
    'hardhackerlabs/theme-vim',
    name = 'hardhacker',
    priority = 1000,
    lazy = false,
    init = function()
      vim.o.termguicolors = true
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      vim.g.hardhacker_keyword_italic = 1
      vim.cmd.hi 'Comment gui=none'
      vim.cmd.colorscheme 'hardhacker'
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- vim.cmd.colorscheme 'tokyonight-storm'
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
}
