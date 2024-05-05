local wezterm = require 'wezterm'
local module = {}

local function h(path)
  if not path then
    return wezterm.home_dir
  end
  return wezterm.home_dir .. "/" .. path
end

function module.get_dirs()
  local project_dirs = { h('Code/*'), h('Code/zendesk/*'), h('Projects/*') }
  local projects = { h(), h('dotfiles') }
  for _, dir in ipairs(project_dirs) do
    for _, p in ipairs(wezterm.glob(dir)) do
      table.insert(projects, p)
    end
  end
  return projects
end

function module.present_input_selector()
  local choices = {}
  for _, value in ipairs(module.get_dirs()) do
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
