local function map(mode, l, r, desc)
  vim.keymap.set(mode, l, r, { desc = desc })
end

-- Unbinds
map('n', '<left>', '<nop>')
map('n', '<right>', '<nop>')
map('n', '<down>', '<nop>')
map('n', '<up>', '<nop>')

-- Window mgmt
map('n', '<C-h>', '<C-w>h', 'Move focus to the left window')
map('n', '<C-l>', '<C-w>l', 'Move focus to the right window')
map('n', '<C-j>', '<C-w>j', 'Move focus to the lower window')
map('n', '<C-k>', '<C-w>k', 'Move focus to the upper window')
map('n', '<leader>sv', '<C-w>v', 'Split window vertically')
map('n', '<leader>sh', '<C-w>s', 'Split window horizontally')
map('n', '<leader>sx', '<CMD>close<CR>', 'Split window horizontally')
map('n', '<leader>s=', '<C-w>=', 'Make panes equal')

-- Buffers
map('n', '<leader>,x', '<CMD>bd<CR>', '[B]uffer [X] Close')
map('n', '<leader>,w', '<CMD>w<CR>', 'Buffer [W]rite')
map('n', '<leader>,wa', '<CMD>wa<CR>', 'Buffer [W]rite [A]ll')
map('n', '<leader>,r', '<cmd>e %<cr>', '[R]eload buffer')
map('n', '<leader>,so', '<cmd>e %<cr>', '[S][O]urce buffer')

-- Move visually selected lines up/down with Shift+J/K
map('v', 'J', ":m '>+1<CR>gv=gv", '[J] Move selected lines up')
map('v', 'K', ":m '<-2<CR>gv=gv", '[K] Move selected lines down')
map('v', '>', '>gv', 'Indent and stay visual')
map('v', '<', '<gv', 'Unindent and stay visual')

-- Movement cursor conveniences
map('n', '<C-u>', '<C-u>zz', 'Page [U]p')
map('n', '<C-d>', '<C-d>zz', 'Page [D]own')
map('n', '<C-k>', '<S-H>zbzz', 'Page half-page up')
map('n', '<C-j>', '<S-L>ztzz', 'Page half-page down')
map('n', 'n', 'nzzzv', 'Next search result')
map('n', 'N', 'Nzzzv', 'Prev search result')
map('n', 'J', 'mzJ`z', 'Join lines')

-- Copy/Pastes
-- map('x', '<leader>y', '"*y', 'Yank to Clipboard')
-- map('x', '<leader>p', '"*p', 'Paste from Clipboard')
map('x', '<leader>p', '"_dP', 'Paste (and keep previous register)')
-- map('n', '<leader>d', '"_d', 'Delete to null register')
-- map('v', '<leader>d', '"_d', 'Delete to null register')

-- Reload

map('n', '<leader>%%', [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], 'Replace word under cursor')
map('n', '<leader>%', [[/\<<C-r><C-w>\><CR>]], 'Search (in file) word under cursor')

-- Diagnostic Hover
map('n', 'KD', function()
  vim.lsp.buf.document_highlight()
  vim.diagnostic.open_float(nil, { focus = false })
end, 'Show Diagnostic float')

-- TELESCOPE File finding
local telescope = require 'telescope.builtin'
map('n', '<leader>ff', function()
  return telescope.find_files { hidden = true }
end, '[F]ind [F]iles (in CWD)')
-- map('n', '<leader>fg', telescope.live_grep:, '[F]ind [G]rep (in CWD)')
map('n', '<leader>fg', function()
  require('telescope').extensions.live_grep_args.live_grep_args { noremap = true }
end, '[F]ind [G]rep (in CWD)')
map('n', '<leader>f%', telescope.grep_string, '[F]ind/Grep String under cursor in project')
map('n', '<leader>fp', telescope.git_files, '[F]ind in Git [P]roject')
map('n', '<leader>fh', telescope.help_tags, '[F]ind in [H]elp')
map('n', '<leader><leader>', telescope.resume, 'Resume Telescope')
map('n', '<leader>.', function()
  telescope.buffers { ignore_current_buffer = true, sort_lastused = true, sort_mru = true }
end, 'Find in Open Buffers')
map('n', '<leader>fr', telescope.oldfiles, '[F]ind in [R]ecent files')
map('n', '<leader>f`', telescope.marks, '[F]ind in [M]arks')
map('n', '<leader>fn', function()
  telescope.find_files { cwd = vim.fn.stdpath 'config' }
end, '[F]ind in [N]eovim Config files')

map('n', '<leader>fa', function()
  vim.cmd [[ Telescope frecency path_display={"shorten"} ]]
end, 'Find with Frecency')

-- Telescope File Browser
-- map('n', '<leader>fb', require('telescope').extensions.file_browser.folder_browser, '[F]ind in File [B]rowser')

-- AutoSession
map('n', '<leader>wr', '<cmd>SessionRestore<cr>', 'Restore session for cwd')
map('n', '<leader>ws', '<cmd>SessionSave<cr>', 'Save session')

-- Quickfix
map('n', '<M-J>', '<cmd>cnext<cr>', 'Next in quicklist')
map('n', '<M-K>', '<cmd>cprev<cr>', 'Prev in quicklist')
map('n', '<M-O>', function()
  -- TODO: add this
end, 'Toggle quicklist window')

-- Conform / Formatting
local conform = require 'conform'
map({ 'n', 'v' }, '<leader>gf', function()
  conform.format { async = true, lsp_fallback = true }
end, 'Format')
