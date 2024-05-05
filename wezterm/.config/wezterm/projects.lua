local wezterm = require 'wezterm'
local module = {}

local function h(path)
  if not path then
    return wezterm.home_dir
  end
  return wezterm.home_dir .. "/" .. path
end

function module.get()
  local project_dirs = { h('Code/*'), h('Projects/*') }
  local projects = { h(), h('dotfiles') }
  for _, dir in ipairs(project_dirs) do
    for _, p in ipairs(wezterm.glob(dir)) do
      table.insert(projects, p)
    end
  end
  return projects
end

return module
