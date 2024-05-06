local wezterm = require 'wezterm'
local color_scheme = require 'color_scheme'
local projects = require 'projects'
local smart_splits = require 'smart_splits'
local act = wezterm.action
local config = wezterm.config_builder()

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
    mods = 'LEADER|CTRL',
    action = act.SendKey { key = 'a', mods = 'CTRL' },
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
      window:perform_action(projects.present_input_selector(), pane)
    end),
  },
}

color_scheme.apply_to_config(config)
smart_splits.apply_to_config(config)

-- add a local_config module for machine specific configuration that
-- shouldn't be committed to the repo.
local has_local_config, local_config = pcall(require, "local_config")
if has_local_config then
  local_config.apply_to_config(config)
end

return config
