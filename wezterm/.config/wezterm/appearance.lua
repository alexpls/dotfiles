-- vim: tabstop=2 shiftwidth=2 expandtab

local wezterm = require 'wezterm'
local module = {}

function module.is_dark()
  -- Hyprland defaults to dark theme
  if wezterm.gui and not os.getenv("XDG_SESSION_DESKTOP") == "Hyprland" then
    -- Some systems report appearance like "Dark High Contrast"
    -- so let's just look for the string "Dark" and if we find
    -- it assume appearance is dark.
    return wezterm.gui.get_appearance():find("Dark")
  end
  -- wezterm.gui is not always available, depending on what
  -- environment wezterm is operating in. Just return true
  -- if it's not defined.
  return true
end

return module
