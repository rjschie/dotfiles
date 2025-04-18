local function filepath()
  return vim.fn.expand '%:gs?src?.?:gs?components?cmpts?'
end

return {
  -- Better Bottom status bar
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    theme = 'catppuccin',
    sections = {
      lualine_c = { filepath },
      lualine_x = { 'searchcount', 'selectioncount' },
      lualine_y = { 'filetype' },
      lualine_z = { 'progress', 'location' },
    },
  },
}
