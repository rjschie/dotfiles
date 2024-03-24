-- Project / File navigation
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Telescope
local telebuiltin = require('telescope.builtin')
vim.keymap.set("n", "<C-p>", telebuiltin.git_files, {})
vim.keymap.set("n", "<leader>ff", telebuiltin.find_files, {})
vim.keymap.set("n", "<leader>fg", telebuiltin.live_grep, {})

-- Harpoon
local harpoon = require('harpoon')
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)

vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

