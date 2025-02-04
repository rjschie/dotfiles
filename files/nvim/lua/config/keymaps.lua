local map = vim.keymap.set

-- Unbinds
map('n', '<left>', '<nop>')
map('n', '<right>', '<nop>')
map('n', '<down>', '<nop>')
map('n', '<up>', '<nop>')

-- Window mgmt
map('n', '<C-h>', '<C-w>h', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move focus to the upper window' })
map('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
map('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
map('n', '<leader>sx', '<CMD>close<CR>', { desc = 'Split window horizontally' })
map('n', '<leader>s=', '<C-w>=', { desc = 'Make panes equal' })

-- Buffers
map('n', '<leader><leader>x', '<CMD>bd<CR>', { desc = '[B]uffer [X] Close' })
map('n', '<leader><leader>w', '<CMD>w<CR>', { desc = 'Buffer [W]rite' })
map('n', '<leader><leader>wa', '<CMD>wa<CR>', { desc = 'Buffer [W]rite [A]ll' })

-- Move visually selected lines up/down with Shift+J/K
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = '[J] Move selected lines up' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = '[K] Move selected lines down' })
map('v', '>', '>gv', { desc = 'Indent and stay visual' })
map('v', '<', '<gv', { desc = 'Unindent and stay visual' })

-- Movement cursor conveniences
map('n', '<C-u>', '<C-u>zz', { desc = 'Page [U]p' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Page [D]own' })
map('n', 'n', 'nzzzv', { desc = 'Next search result' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search result' })
map('n', 'J', 'mzJ`z', { desc = 'Join lines' })

-- Copy/Pastes
-- map('x', '<leader>y', '"*y', { desc = 'Yank to Clipboard' })
-- map('x', '<leader>p', '"*p', { desc = 'Paste from Clipboard' })
-- map('x', '<leader>p', '"_dP', { desc = 'Paste (and keep previous register)' })
-- map('n', '<leader>d', '"_d', { desc = 'Delete to null register' })
-- map('v', '<leader>d', '"_d', { desc = 'Delete to null register' })

-- Reload
map('n', '<leader>,r', '<cmd>e %<cr>', { desc = '[R]eload file' })

map('n', '<leader>%', [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })
-- map('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format lines' })

-- TELESCOPE File finding
local telescope = require 'telescope.builtin'
map('n', '<leader>ff', telescope.find_files, { desc = '[F]ind [F]iles (in CWD)' })
map('n', '<leader>fg', telescope.live_grep, { desc = '[F]ind [G]rep (in CWD)' })
map('n', '<leader>f%', telescope.grep_string, { desc = '[F]ind/Grep String under cursor' })
map('n', '<leader>fp', telescope.git_files, { desc = '[F]ind in Git [P]roject' })
map('n', '<leader>fh', telescope.help_tags, { desc = '[F]ind in [H]elp' })
map('n', '<leader><leader>', telescope.resume, { desc = 'Resume Telescope' })
map('n', '<leader>.', function()
  telescope.buffers { ignore_current_buffer = true, sort_lastused = true, sort_mru = true }
end, { desc = 'Find in Open Buffers' })
map('n', '<leader>fr', telescope.oldfiles, { desc = '[F]ind in [R]ecent files' })
map('n', '<leader>f`', telescope.marks, { desc = '[F]ind in [M]arks' })
map('n', '<leader>fn', function()
  telescope.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[F]ind in [N]eovim Config files' })

-- AutoSession
-- map('n', '<leader>wr', '<cmd>SessionRestore<cr>', { desc = 'Restore session for cwd' })
-- map('n', '<leader>ws', '<cmd>SessionSave<cr>', { desc = 'Save session' })
