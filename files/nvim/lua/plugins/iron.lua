return {
  -- Python REPL
  'Vigemus/iron.nvim',
  enabled = false,
  config = function()
    local iron = require 'iron.core'

    iron.setup {
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = { 'python3' },
            format = require('iron.fts.common').bracketed_paste_python,
          },
        },
        repl_open_cmd = require('iron.view').bottom(40),
      },
      keymaps = {
        send_file = '<leader>rsf',
        send_line = '<leader>rsl',
        send_paragraph = '<leader>rsp',
        cr = '<leader>rs<cr>',
        interrupt = '<leader>rs<space>',
        exit = '<leader>rsq',
        clear = '<leader>rsc',
      },
      ignore_blank_lines = true,
    }

    vim.keymap.set('n', '<leader>rss', '<cmd>IronRepl<cr>')
  end,
}
