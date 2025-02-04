return {
  {
    -- Better Netrw File explorer
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    config = function()
      function _G.get_oil_winbar()
        local dir = require('oil').get_current_dir()
        if dir then
          return vim.fn.fnamemodify(dir, ':~')
        else
          return vim.api.nvim_buf_get_name(0)
        end
      end

      require('oil').setup {
        columns = {
          'icon',
          -- "permission",
          -- "size",
          -- "mtime",
        },
        delete_to_trash = true,
        view_options = {
          show_hidden = true,
        },
        -- win_options = {
        --   winbar = '%!v:lua.get_oil_winbar()',
        -- },
        -- keymaps = {
        --   ['-'] = function()
        --     require('oil.actions').parent.callback()
        --     vim.cmd.lcd(require('oil').get_current_dir())
        --   end,
        --   ['<CR>'] = function()
        --     require('oil').select(nil, function(err)
        --       if not err then
        --         local curdir = require('oil').get_current_dir()
        --         if curdir then
        --           vim.cmd.lcd(curdir)
        --         end
        --       end
        --     end)
        --   end,
        -- },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<space>-', require('oil').toggle_float)
    end,
  },
}
