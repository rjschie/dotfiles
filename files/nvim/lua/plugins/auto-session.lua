return {
  -- Session management
  'rmagatti/auto-session',
  -- @module "auto-session"
  -- @type AutoSession.Config
  opts = {
    auto_restore = false,
  },
  init = function()
    vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  end,
}
