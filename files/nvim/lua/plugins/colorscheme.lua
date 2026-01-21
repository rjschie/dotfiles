local theme = 'tokyonight'

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    enabled = true,
    config = function()
      require('catppuccin').setup {
        flavour = 'frappe',
        transparent_background = true,
        -- color_overrides = {
        --   all = {
        --     rosewater = '#f4dbd6',
        --     flamingo = '#f6c3c3',
        --     pink = '#f5bde6',
        --     mauve = '#e890e5',
        --     red = '#f98691',
        --     maroon = '#ee99a0',
        --     peach = '#f5a97f',
        --     yellow = '#f6d28a',
        --     green = '#a7da96',
        --     teal = '#54dae8',
        --     sky = '#67ddf0',
        --     sapphire = '#7dc4e4',
        --     blue = '#f98691',
        --     lavender = '#b7bdf8',
        --     text = '#c5c7fc',
        --     subtext1 = '#b5b4d7',
        --     subtext0 = '#adaac4',
        --     overlay2 = '#a4a0b1',
        --     overlay1 = '#8b8798',
        --     overlay0 = '#736f7f',
        --     surface2 = '#5a5666',
        --     surface1 = '#413d4d',
        --     surface0 = '#353140',
        --     base = '#1e1b27',
        --     mantle = '#14121a',
        --     crust = '#0a090d',
        --   },
        -- },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'hardhackerlabs/theme-vim',
    name = 'hardhacker',
    priority = 1000,
    lazy = false,
    enabled = true,
    init = function()
      vim.o.termguicolors = true
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      vim.g.hardhacker_keyword_italic = 1
      -- vim.cmd.hi 'Comment gui=none'
      -- vim.cmd.colorscheme 'hardhacker'
    end,
  },
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    lazy = false,
    enabled = true,
    -- config = function()
    --   vim.cmd.colorscheme 'tokyonight-storm'
    --
    --   require('tokyonight').setup {
    --     style = 'storm',
    --     on_colors = function(colors)
    --       print(colors)
    --       -- colors.bg =
    --     end,
    --   }
    -- end,
    init = function()
      -- vim.cmd.colorscheme 'tokyonight-storm'
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
}
