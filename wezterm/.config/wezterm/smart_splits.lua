local wezterm = require('wezterm')
local act = wezterm.action
local module = {}

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local resize_keys = {
  h = '>',
  j = '-',
  k = '+',
  l = '<',
}

local function is_vim(pane)
  -- assumes smart-splits has been installed on the
  -- nvim side.
  return pane:get_user_vars().IS_NVIM == 'true'
end

local function resize(key)
  return wezterm.action_callback(function(window, pane)
    if is_vim(pane) then
      window:perform_action(
        wezterm.action.Multiple {
          act.SendKey { key = 'w', mods = 'CTRL' },
          act.SendKey { key = resize_keys[key] },
        }
        , pane)
    else
      window:perform_action({
        AdjustPaneSize = { direction_keys[key], 3 }
      }, pane)
    end
  end)
end

local function move(key)
  return wezterm.action_callback(function(window, pane)
    if is_vim(pane) then
      window:perform_action(
        wezterm.action.Multiple {
          act.SendKey { key = 'w', mods = 'CTRL' },
          act.SendKey { key = key },
        }
        , pane)
    else
      window:perform_action({
        ActivatePaneDirection = direction_keys[key]
      }, pane)
    end
  end)
end

function module.apply_to_config(config)
  local keys = {
    {
      key = 'j',
      mods = 'LEADER',
      action = move('j'),
    },
    {
      key = 'k',
      mods = 'LEADER',
      action = move('k'),
    },
    {
      key = 'h',
      mods = 'LEADER',
      action = move('h'),
    },
    {
      key = 'l',
      mods = 'LEADER',
      action = move('l'),
    },
    {
      key = 'r',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'resize_panes',
        timeout_milliseconds = 800,
        one_shot = false,
      },
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
  }

  if not config.keys then
    config.keys = {}
  end
  for _, k in ipairs(keys) do
    table.insert(config.keys, k)
  end

  if not config.key_tables then
    config.key_tables = {}
  end
  config.key_tables.resize_panes = {
    {
      key = 'j',
      action = resize('j'),
    },
    {
      key = 'k',
      action = resize('k'),
    },
    {
      key = 'h',
      action = resize('h'),
    },
    {
      key = 'l',
      action = resize('l'),
    },
  }
end

return module
