return {
  -- Maximize a vim split, similar to TMUX
  'szw/vim-maximizer',
  keys = {
    { '<leader>sm', '<cmd>MaximizerToggle<cr>', desc = 'Maximize/Minimize a split' },
  },
}
