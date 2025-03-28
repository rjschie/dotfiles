return {
  -- Maximize a vim split, similar to TMUX
  'szw/vim-maximizer',
  keys = {
    { '<c-m>', '<cmd>MaximizerToggle<cr>', desc = 'Maximize/Minimize a split' },
  },
}
