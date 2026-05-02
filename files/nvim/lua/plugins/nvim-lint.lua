return {
  'mfussenegger/nvim-lint',
  enabled = true,
  -- event = { 'BufReadPre', 'BufNewFile' },
  -- event = 'LazyFile',
  config = function()
    local lint = require 'lint'
    local util = require 'config.util'

    lint.linters_by_ft = {
      python = { 'pylint' },
      lua = { 'luacheck' },
    }

    local js_filetypes = {
      javascript = true,
      typescript = true,
      javascriptreact = true,
      typescriptreact = true,
    }

    --- Pick js linters declared in this buffer's package.json chain, and
    --- point each at the nearest node_modules/.bin binary if present.
    ---@param bufnr integer
    ---@return string[]
    local function js_linters_for_buf(bufnr)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      if fname == '' then
        return {}
      end
      local dir = vim.fs.dirname(fname)
      local ctx = { dirname = dir }
      local result = {}
      local saw_package_json = util.has_any_package_json(dir)
      for _, name in ipairs { 'oxlint', 'eslint' } do
        if saw_package_json then
          if util.declared_in_package_json(name, ctx) then
            local bin = util.find_local_bin(name, dir)
            if bin then
              lint.linters[name].cmd = bin
            end
            table.insert(result, name)
          end
        else
          if vim.fn.executable(name) == 1 then
            lint.linters[name].cmd = name
            table.insert(result, name)
          end
        end
      end
      return result
    end

    vim.api.nvim_create_user_command('LintInfo', function()
      local bufnr = vim.api.nvim_get_current_buf()
      local ft = vim.bo[bufnr].filetype
      local names = js_filetypes[ft] and js_linters_for_buf(bufnr) or (lint.linters_by_ft[ft] or {})
      local lines = { 'Linters for buffer (ft=' .. ft .. '):' }
      if #names == 0 then
        table.insert(lines, '  (none)')
      end
      for _, name in ipairs(names) do
        local def = lint.linters[name] or {}
        local cmd = type(def.cmd) == 'function' and def.cmd() or def.cmd or '?'
        table.insert(lines, string.format('  %s -> %s', name, cmd))
      end
      local running = lint.get_running(bufnr)
      table.insert(lines, 'Running: ' .. (#running > 0 and table.concat(running, ', ') or '(none)'))
      vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
    end, { desc = 'Show linters chosen for current buffer' })

    local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function(args)
        if js_filetypes[vim.bo[args.buf].filetype] then
          local linters = js_linters_for_buf(args.buf)
          if #linters > 0 then
            lint.try_lint(linters)
          end
          return
        end
        lint.try_lint()
      end,
    })
  end,
}
