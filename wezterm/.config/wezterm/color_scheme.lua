local wezterm = require 'wezterm'
local module = {}

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Tokyo Night'
  else
    return 'Tokyo Night Day'
  end
end

function module.apply_to_config(config)
  local a = get_appearance()
  config.color_scheme = scheme_for_appearance(a)
end

return module
