return {
  -- Better Bottom status bar
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    theme = 'catppuccin',
    sections = {
      lualine_x = { 'searchcount', 'selectioncount' },
      lualine_y = { 'filetype' },
      lualine_z = { 'progress', 'location' },
    },
  },
}
