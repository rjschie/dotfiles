return {
  -- Autoformat
  'stevearc/conform.nvim',
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- notify_on_error = true, -- (default)
    -- log_level = vim.log.levels.DEBUG,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        async = true,
        -- timeout_ms = 1000,
        -- lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        lsp_fallback = false,
      }
    end,
    formatters = {
      localoxfmt = function()
        local util = require 'conform.util'
        return {
          command = util.from_node_modules 'oxfmt',
          args = { '$FILENAME' },
          stdin = false,
          tmpfile_format = '.conform.$RANDOME.$FILENAME',
        }
      end,
      localprettier = function()
        local util = require 'conform.util'
        return {
          command = util.from_node_modules 'prettier',
          args = { '--stdin-filepath', '$FILENAME' },
          stdin = true,
        }
      end,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'localoxfmt', 'localprettier' },
      javascriptreact = { 'localoxfmt', 'localprettier' },
      typescript = { 'localoxfmt', 'localprettier' },
      typescriptreact = { 'localoxfmt' },
      css = { 'localoxfmt', 'localprettier' },
      html = { 'localoxfmt', 'localprettier' },
      json = { 'localoxfmt', 'localprettier' },
      yaml = { 'localoxfmt', 'localprettier' },
      markdown = { 'localoxfmt', 'localprettier' },
    },
  },
  -- init = function()
  --   local conform = require 'conform'
  --   vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
  --     conform.format()
  --   end, { desc = 'Format file' })
  -- end,
}
