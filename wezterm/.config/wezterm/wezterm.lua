local wezterm = require 'wezterm'
local appearance = require 'appearance'
local projects = require 'projects'
local smart_splits = require 'smart_splits'
local act = wezterm.action
local config = wezterm.config_builder()

local is_linux = function()
  return wezterm.target_triple:find("linux") ~= nil
end

if appearance.is_dark() then
  config.color_scheme = 'Tokyo Night'
else
  config.color_scheme = 'Tokyo Night Day'
end

config.font = wezterm.font('Berkeley Mono')
config.font_size = is_linux() and 12 or 15

config.window_background_opacity = 0.97
config.macos_window_background_blur = 30
if not is_linux() then
  config.window_decorations = "RESIZE"
end
config.window_frame = {
  font = wezterm.font({ family = 'Berkeley Mono', weight = 'Bold' }),
  font_size = is_linux() and 9 or 11,
}

wezterm.on('update-status', function(window, _)
  local segments = projects.list_for_display()

  local color_scheme = window:effective_config()
  local active_color = wezterm.color.parse(color_scheme.window_frame.button_fg)
  local inactive_color = active_color:darken(0.3)

  -- We'll build up the elements to send to wezterm.format in this table.
  local elements = {}

  for _, seg in ipairs(segments) do
    if seg.active then
      table.insert(elements, { Foreground = { Color = active_color } })
    else
      table.insert(elements, { Foreground = { Color = inactive_color } })
    end
    table.insert(elements, { Background = { Color = 'none' } })
    table.insert(elements, { Text = seg.label })
  end

  table.insert(elements, { Text = ' ' }) -- a bit of padding

  window:set_right_status(wezterm.format(elements))
end)

config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

config.leader = { key = 'p', mods = 'CTRL', timeout_milliseconds = 1000 }
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
    key = ' ',
    mods = 'LEADER|CTRL',
    action = act.SendKey { key = ' ', mods = 'CTRL' },
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  {
    key = 'f',
    mods = 'LEADER',
    action = projects.choose_project(),
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      projects.switch_by_id(i, window, pane)
    end),
  })
  -- tmux window switching: super-num sends alt-num to tmux
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'SUPER',
    action = act.SendString('\x1b' .. tostring(i)),
  })
end

smart_splits.apply_to_config(config)

-- add a local_config module for machine specific configuration that
-- shouldn't be committed to the repo.
local has_local_config, local_config = pcall(require, "local_config")
if has_local_config then
  local_config.apply_to_config(config)
end

return config
