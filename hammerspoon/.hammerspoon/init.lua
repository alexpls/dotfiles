hs.hotkey.bind({ "cmd" }, "escape", function()
  local term = hs.application.find("Wezterm")
  if term == nil then
    term = hs.application.open("Wezterm.app")
  end
  if term:isFrontmost() then
    term:hide()
  else
    term:setFrontmost()
  end
end)
