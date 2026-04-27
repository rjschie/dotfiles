return {
  'mfussenegger/nvim-lint',
  enabled = true,
  -- event = { 'BufReadPre', 'BufNewFile' },
  -- event = 'LazyFile',
  config = function()
    local lint = require 'lint'

    --- Resolve absolute path to a node_modules/.bin command
    ---@param cmd string
    ---@return string
    local function local_bin(cmd)
      return vim.fn.fnamemodify('node_modules/.bin/' .. cmd, ':p')
    end

    --- Build list of linters available in node_modules
    local js_linters = {}
    for _, name in ipairs { 'oxlint', 'eslint' } do
      local bin = local_bin(name)
      if vim.uv.fs_stat(bin) then
        lint.linters[name].cmd = bin
        table.insert(js_linters, name)
      end
    end

    lint.linters_by_ft = {
      javascript = js_linters,
      typescript = js_linters,
      javascriptreact = js_linters,
      typescriptreact = js_linters,
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
