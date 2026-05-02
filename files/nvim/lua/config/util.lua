local M = {}

--- True if any package.json between ctx.dirname and the git root declares
--- `pkg` in dependencies/devDependencies. Stops at the directory containing
--- `.git` (inclusive) so we don't escape the repo into $HOME or `/`.
function M.declared_in_package_json(pkg, ctx)
  local dir = ctx.dirname
  while dir and dir ~= '' do
    local candidate = dir .. '/package.json'
    if vim.uv.fs_stat(candidate) then
      local ok, content = pcall(vim.fn.readfile, candidate)
      if ok then
        local decoded_ok, json = pcall(vim.json.decode, table.concat(content, '\n'))
        if decoded_ok and type(json) == 'table' then
          if (json.dependencies and json.dependencies[pkg] ~= nil)
            or (json.devDependencies and json.devDependencies[pkg] ~= nil) then
            return true
          end
        end
      end
    end
    if vim.uv.fs_stat(dir .. '/.git') then
      break
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
  return false
end

--- True if any package.json exists between `dir` and the git root.
function M.has_any_package_json(dir)
  while dir and dir ~= '' do
    if vim.uv.fs_stat(dir .. '/package.json') then
      return true
    end
    if vim.uv.fs_stat(dir .. '/.git') then
      return false
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      return false
    end
    dir = parent
  end
  return false
end

--- Find the closest node_modules/.bin/<cmd> walking up from `dir`.
--- Returns absolute path or nil.
function M.find_local_bin(cmd, dir)
  local nm = vim.fs.find('node_modules', { upward = true, path = dir, type = 'directory' })[1]
  if not nm then
    return nil
  end
  local bin = nm .. '/.bin/' .. cmd
  if vim.uv.fs_stat(bin) then
    return bin
  end
  return nil
end

return M
