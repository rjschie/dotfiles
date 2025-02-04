return {
  -- Startup landing page customiser
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      '                                                     ',
      '                                                     ',
      '                 This is NeoVim                      ',
      '                                                     ',
      '                                                     ',
    }

    dashboard.section.buttons.val = {
      dashboard.button('e', '> New File', '<cmd>ene<cr>'),
      --dashboard.button("SPC ee", "", ""),
      dashboard.button('SPC ff', '> Find File', '<cmd>Telescope find_files<cr>'),
      dashboard.button('SPC fg', '> Find Word', '<cmd>Telescope live_grep<cr>'),
      dashboard.button('SPC wr', '> Restore session for cwd', '<cmd>SessionRestore<cr>'),
      dashboard.button('q', 'Quit', '<cmd>qa<cr>'),
    }

    alpha.setup(dashboard.opts)
  end,
}
