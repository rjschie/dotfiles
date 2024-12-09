-- Add any additional keymaps here

vim.keymap.set('n', '<left>', '<nop>')
vim.keymap.set('n', '<right>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('n', '<up>', '<nop>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: using Oil, I just set it to `-`
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open cwd files' })

-- Move visually selected lines up/down with Shift+J/K
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = '[J] Move selected lines up' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = '[K] Move selected lines down' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent and stay visual' })
vim.keymap.set('v', '<', '<gv', { desc = 'Unindent and stay visual' })

vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page [U]p' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page [D]own' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Prev search result' })

-- Paste and keep new buffer
-- TODO: set it to regular `p` in Visual mode only
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste (and keep buffer)' })
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Delete to null register' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'Delete to null register' })

vim.keymap.set('n', '<leader>%', [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })

-- vim.keymap.set('n', 'zt', 'za', { desc = 'Toggle fold (alias for za)' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines' })
-- vim.keymap.set('n', '<S-CR>', 'O<Esc>')
-- vim.keymap.set('n', '<CR>', 'o<Esc>')

-- TODO: Look into needing this
-- vim.keymap.set('n', 'Q', '<nop>')

-- TODO: Look into needing this? Or if Kickstart has another way
-- vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format lines' })
