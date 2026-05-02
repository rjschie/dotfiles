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
        timeout_ms = 2000,
        -- lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        lsp_fallback = false,
      }
    end,
    formatters = {
      localoxfmt = function()
        local util = require 'conform.util'
        return {
          command = util.from_node_modules 'oxfmt',
          args = { '--stdin-filepath', '$FILENAME' },
          stdin = true,
          condition = function(_, ctx)
            return require('config.util').declared_in_package_json('oxfmt', ctx)
          end,
        }
      end,
      localprettier = function()
        local util = require 'conform.util'
        return {
          command = util.from_node_modules 'prettier',
          args = { '--stdin-filepath', '$FILENAME' },
          stdin = true,
          condition = function(_, ctx)
            return require('config.util').declared_in_package_json('prettier', ctx)
          end,
        }
      end,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      javascriptreact = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      typescript = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      typescriptreact = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      css = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      html = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      json = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      jsonl = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      jsonc = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      yaml = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
      markdown = { 'localoxfmt', 'localprettier', 'oxfmt', stop_after_first = true },
    },
  },
  -- init = function()
  --   local conform = require 'conform'
  --   vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
  --     conform.format()
  --   end, { desc = 'Format file' })
  -- end,
}
