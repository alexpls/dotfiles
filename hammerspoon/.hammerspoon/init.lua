hs.loadSpoon("EmmyLua") -- generate lua annotations for LSP

local function toggleWezterm()
  local term = hs.application.find("Wezterm")
  if term == nil then
    term = hs.application.open("Wezterm.app")
  end
  if term:isFrontmost() then
    term:hide()
  else
    term:setFrontmost()
  end
end

hs.hotkey.bind({ "cmd" }, "escape", toggleWezterm)

local listener = hs.noises.new(function(num)
  if num == 3 then
    toggleWezterm()
  end
end)

local frivolous = false

local chooser = hs.chooser.new(function(choice)
  if choice == nil then return end
  handleChoice(choice)
end)

function handleChoice(choice)
  local command = choice["command"]
  if command == "ceaseFrivolity" then
    ceaseFrivolity()
  elseif command == "beginFrivolity" then
    beginFrivolity()
  end
end

function ceaseFrivolity()
  frivolous = false
  listener:stop()
  chooser:refreshChoicesCallback()
end

function beginFrivolity()
  frivolous = true
  listener:start()
  chooser:refreshChoicesCallback()
end

chooser:choices(function()
  local c = {}
  if frivolous then
    table.insert(c, {
      ["text"] = "Cease frivolity",
      ["subText"] = "Time to get serious",
      ["command"] = "ceaseFrivolity",
    })
  else
    table.insert(c, {
      ["text"] = "Begin frivolity",
      ["subText"] = 'Utter a "pop", I dare you',
      ["command"] = "beginFrivolity",
    })
  end
  return c
end)

hs.hotkey.bind({ "cmd" }, "\\", function()
  chooser:show()
end)

-- cmd+shift+c to copy current URL in firefox, mimicing arc browser
--
-- one day firefox might support applescript, in which case this
-- could be made more robust: https://bugzilla.mozilla.org/show_bug.cgi?id=125419
local firefoxOpenUrlHotkey = hs.hotkey.new({ "cmd", "shift" }, "c", function()
  local ff = hs.application.find("Firefox")
  if ff and ff:isFrontmost() then
    hs.eventtap.keyStroke({ "cmd" }, "l", 0, ff) -- focus address bar
    hs.eventtap.keyStroke({ "cmd" }, "c", 0, ff) -- copy contents
    hs.eventtap.keyStroke({}, "escape", 0, ff)   -- unfocus address bar
  end
end)
local firefoxFilter = hs.window.filter.new("Firefox")
firefoxFilter
    :subscribe(hs.window.filter.windowFocused, function()
      firefoxOpenUrlHotkey:enable()
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
      firefoxOpenUrlHotkey:disable()
    end)
