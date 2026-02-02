return {
  'mfussenegger/nvim-lint',
  enabled = true,
  -- event = { 'BufReadPre', 'BufNewFile' },
  -- event = 'LazyFile',
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      javascript = { 'oxlint' },
      typescript = { 'oxlint' },
      javascriptreact = { 'oxlint' },
      typescriptreact = { 'oxlint' },
      python = { 'pylint' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
