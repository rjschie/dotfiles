return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        opts = {
            ensure_installed = { "javascript", "typescript", "c", "lua", "vim", "vimdoc", "query" },
            sync_install = false, -- Install parsers synchronously
            auto_install = true,
            -- ignore_install = {},
            highlight = {
                enabled = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        },
    },
}
