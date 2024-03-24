return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            vim.opt.termguicolors = true
            vim.cmd.colorscheme("catppuccin-mocha")
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        lazy = false,
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'tpope/vim-surround',
    'tpope/vim-commentary',
}
