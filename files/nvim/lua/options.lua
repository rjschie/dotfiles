-- Hint: use `:h <option>` to see meaning
--vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4		    -- insert spaces on tab
vim.opt.expandtab = true	    -- tabs are spaces

-- UI config
vim.opt.number = true		    -- show absolute number
vim.opt.relativenumber = true	-- add numbers to each line on left
vim.opt.splitbelow = true       -- default split below
vim.opt.splitright = true       -- default split right
vim.opt.showmode = false        -- no `-- INSERT --` shown

-- Searching
vim.opt.incsearch = true        -- search as characters are entered
vim.opt.hlsearch = false        -- do not highlight all matches
vim.opt.ignorecase = true       -- ignore case in searches by default
vim.opt.smartcase = true        -- but make it case sensitive if uppercases used

