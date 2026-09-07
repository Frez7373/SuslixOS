local ui = dofile("/sys/ui.lua")
local config = dofile("/lib/config.lua")

local themes = {"blue", "green", "purple", "dark"}
local wallpapers = {"plain", "grid", "lines"}

local function nextValue(list, value)
  for i,v in ipairs(list) do
    if v == value then return list[i % #list + 1] end
  end
  return list[1]
end

local function save(s)
  local ok, err = config.save(s)
  if not ok then
    ui.message("Could not save", tostring(err))
    return false
  end
  if s.name and s.name ~= "" and os.setComputerLabel then pcall(os.setComputerLabel, s.name) end
  return true
end

local s = config.load()
s.name = os.getComputerLabel() or "SuslixOS Computer"

while true do
  local c = config.colors(s.theme)
  ui.clear(c.bg)
  ui.header("Settings", c.surface, c.text)
  local w,h = term.getSize()
  term.setTextColor(c.text)

  term.setCursorPos(3,3); term.write("Appearance")
  term.setCursorPos(3,4); term.write("1  Theme       " .. s.theme)
  term.setCursorPos(3,5); term.write("2  Background  " .. s.wallpaper)
  term.setCursorPos(3,6); term.write("3  Effects     " .. (s.animations == "true" and "On" or "Off"))

  term.setCursorPos(3,8); term.write("Clock")
  term.setCursorPos(3,9); term.write("4  Format      " .. (s.clock24 == "true" and "24-hour" or "12-hour"))
  term.setCursorPos(3,10); term.write("5  Show clock  " .. (s.showClock == "true" and "On" or "Off"))

  term.setCursorPos(3,12); term.write("Computer")
  term.setCursorPos(3,13); term.write("6  Name        " .. s.name:sub(1, math.max(1,w-18)))
  term.setCursorPos(3,15); term.write("7  Save now")
  term.setCursorPos(3,16); term.write("8  Restore defaults")
  term.setCursorPos(3,17); term.write("9  My Apps & Shortcuts")
  ui.footer("Press a number • Changes are saved automatically • Q back", c.panel, c.text)

  local e,k = os.pullEvent()
  if e == "key" then
    if k == keys.q then return
    elseif k == keys.one then s.theme = nextValue(themes, s.theme); save(s)
    elseif k == keys.two then s.wallpaper = nextValue(wallpapers, s.wallpaper); save(s)
    elseif k == keys.three then s.animations = (s.animations == "true" and "false" or "true"); save(s)
    elseif k == keys.four then s.clock24 = (s.clock24 == "true" and "false" or "true"); save(s)
    elseif k == keys.five then s.showClock = (s.showClock == "true" and "false" or "true"); save(s)
    elseif k == keys.six then
      term.setCursorPos(3,19); term.clearLine(); write("New computer name: ")
      local n = read()
      if n ~= "" then s.name = n; save(s) end
    elseif k == keys.seven then
      save(s); ui.message("Saved", "Your settings are saved and will survive a reboot.")
    elseif k == keys.eight then
      s = config.defaults
      s.name = os.getComputerLabel() or "SuslixOS Computer"
      save(s)
      ui.message("Defaults restored", "The appearance has been reset.")
    elseif k == keys.nine then shell.run("/apps/bookmarks.lua") end
  end
end
