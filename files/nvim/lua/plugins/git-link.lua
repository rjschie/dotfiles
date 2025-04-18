return {
  'juacker/git-link.nvim',
  keys = {
    {
      '<leader>hlc',
      function()
        require('git-link.main').copy_line_url()
      end,
      desc = 'Copy code [L]ink to clipboard',
      mode = { 'n', 'x' },
    },
    {
      '<leader>hlo',
      function()
        require('git-link.main').open_line_url()
      end,
      desc = 'Open code [L]ink in browser',
      mode = { 'n', 'x' },
    },
  },
}
