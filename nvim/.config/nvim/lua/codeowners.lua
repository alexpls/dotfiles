-- Assumes you've installed:
-- https://github.com/hmarr/codeowners

codeowners = {}

local codeowners_path = function()
  local dirs = vim.fs.find(
    {'.github', 'docs'},
    {type = 'directory', upward = true}
  )

  if #dirs == 0 then
    return nil
  end

  for k, v in ipairs(dirs) do
    local co_path = v .. "/CODEOWNERS"
    if io.open(co_path, "r") then
      return co_path
    end
  end

  return nil
end

local codeowners_cmd = function()
  local cmd = "codeowners"
  local ret = vim.system({"command", "-v", cmd}):wait()
  if ret.code == 0 then
    return cmd
  end
  return nil
end

local parse_output_line = function(line)
  local words = {}
  for w in line:gmatch("%S+") do
    table.insert(words, w)
  end
  local out = { file = nil, owners = {} }
  for i, w in ipairs(words) do
    if i == 1 then
      out.file = w
    else
      table.insert(out.owners, w)
    end
  end
  return out
end

codeowners.for_file = function(path)
  local cmd = codeowners_cmd()
  local co_path = codeowners_path()

  if co_path == nil or cmd == nil then
    return nil
  end

  local ret = vim.system({cmd, path}, { text = true }):wait()
  local out = ret.stdout
  return parse_output_line(out)
end

codeowners.print = function()
  local buf_relative_path = vim.fn.expand("%")
  local co = codeowners.for_file(buf_relative_path)
  if co == nil then
    vim.print("Couldn't determine CODEOWNERS. " ..
      "Does this project have a .github/CODEOWNERS file? " ..
      "Is the codeowners program installed?")
    return
  end
  vim.print(table.concat(co.owners, ", "))
end

vim.api.nvim_create_user_command('Codeowners', function()
  codeowners.print()
end, {})

return codeowners

