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
