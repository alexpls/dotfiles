local wezterm = require 'wezterm'
local module = {}

local function h(path)
  if not path then
    return wezterm.home_dir
  end
  return wezterm.home_dir .. "/" .. path
end

local function project_dirs()
  local dirs = { h('code/*'), h('Code/*'), h('Code/zendesk/*'), h('Projects/*') }
  local projects = { h(), h('dotfiles') }
  for _, dir in ipairs(dirs) do
    for _, p in ipairs(wezterm.glob(dir)) do
      table.insert(projects, p)
    end
  end
  return projects
end

function module.list_for_display()
  local active = wezterm.mux.get_active_workspace()
  local workspaces = wezterm.mux.get_workspace_names()

  local projects = {}

  for i, val in ipairs(workspaces) do
    local workspace_str = i .. ": " .. val
    if active == val then
      table.insert(projects, {
        label = "[" .. workspace_str .. "]",
        active = true,
      })
    else
      table.insert(projects, {
        label = " " .. workspace_str .. " ",
        active = false
      })
    end
  end

  return projects
end

function module.switch_by_id(id, window, pane)
  local workspaces = wezterm.mux.get_workspace_names()
  local workspace = workspaces[id]
  if not workspace then return end
  window:perform_action(
    wezterm.action.SwitchToWorkspace { name = workspace },
    pane
  )
end

function module.choose_project()
  local choices = {}
  for _, value in ipairs(project_dirs()) do
    table.insert(choices, { label = value })
  end

  return wezterm.action.InputSelector {
    title = "Workspaces",
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      if label then
        child_window:perform_action(wezterm.action.SwitchToWorkspace {
          name = label:match("([^/]+)$"),
          spawn = {
            cwd = label,
          }
        }, child_pane)
      end
    end),
  }
end

return module
