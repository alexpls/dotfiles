local wezterm = require 'wezterm'
local color_scheme = require 'color_scheme'
local projects = require 'projects'
local act = wezterm.action
local config = wezterm.config_builder()

color_scheme.apply_to_config(config)

config.font = wezterm.font('Berkeley Mono')
config.font_size = 13

config.window_background_opacity = 0.95
config.macos_window_background_blur = 40
config.window_decorations = "RESIZE"
config.window_padding = {
  top = '0.5cell',
  bottom = 0,
  left = '1cell',
  right = '1cell',
}
config.window_frame = {
  font = wezterm.font({ family = 'Berkeley Mono', weight = 'Bold' }),
  font_size = 11,
}

wezterm.on('update-right-status', function(window, _)
  local t = #wezterm.mux.get_workspace_names()
  window:set_right_status(wezterm.format({
    { Text = " " .. window:active_workspace() .. " (" .. t .. ") " },
  }))
end)

config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendString '\x1bb',
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendString '\x1bf',
  },
  {
    key = ',',
    mods = 'SUPER',
    action = act.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
      args = { 'nvim', wezterm.config_file },
    },
  },
  {
    key = 'a',
    mods = 'CTRL',
    action = act.SendKey { key = 'a', mods = 'CTRL' },
  },
  {
    key = '%',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '"',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      local project_dirs = projects.get()
      local choices = {}

      for _, value in ipairs(project_dirs) do
        table.insert(choices, { label = value })
      end

      window:perform_action(
        act.InputSelector {
          title = "Workspaces",
          choices = choices,
          fuzzy = true,
          action = wezterm.action_callback(function(child_window, child_pane, id, label)
            if label then
              child_window:perform_action(act.SwitchToWorkspace {
                name = label:match("([^/]+)$"),
                spawn = {
                  cwd = label,
                }
              }, child_pane)
            end
          end),
        },
        pane
      )
    end),
  },
}

return config
