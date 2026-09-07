local ui = dofile("/sys/ui.lua")
local config = dofile("/lib/config.lua")
local s = config.load()
local themes = {"blue","green","purple","dark"}
local wallpapers = {"grid","plain","lines"}

local function save()
  config.save(s)
  if s.showClock == "true" then pcall(os.setComputerLabel, s.name or os.getComputerLabel() or "SuslixOS Computer") end
end

local function choose(list,current)
  for i,v in ipairs(list) do if v==current then return i end end
  return 1
end

while true do
  local c=config.colors(s.theme); ui.clear(c.bg); ui.header("⚙ Settings",c.surface,c.text)
  local w,h=term.getSize()
  term.setTextColor(c.text); term.setBackgroundColor(c.bg)
  term.setCursorPos(3,3); term.write("Appearance")
  term.setCursorPos(3,4); term.write("1. Theme: "..s.theme)
  term.setCursorPos(3,5); term.write("2. Wallpaper: "..s.wallpaper)
  term.setCursorPos(3,6); term.write("3. Animations: "..(s.animations=="true" and "ON" or "OFF"))
  term.setCursorPos(3,8); term.write("System")
  term.setCursorPos(3,9); term.write("4. Computer name: "..(os.getComputerLabel() or "SuslixOS Computer"))
  term.setCursorPos(3,10); term.write("5. Clock: "..(s.clock24=="true" and "24-hour" or "12-hour"))
  term.setCursorPos(3,11); term.write("6. Show clock: "..(s.showClock=="true" and "ON" or "OFF"))
  term.setCursorPos(3,13); term.write("7. Save changes")
  term.setCursorPos(3,14); term.write("8. Reset settings")
  term.setCursorPos(3,15); term.write("9. Favorites & Apps")
  ui.footer("1-9 select • Q back",c.panel,c.text)
  local e,k=os.pullEvent()
  if e=="key" then
    if k==keys.q then return
    elseif k==keys.one then local n=choose(themes,s.theme); s.theme=themes[n%#themes+1]
    elseif k==keys.two then local n=choose(wallpapers,s.wallpaper); s.wallpaper=wallpapers[n%#wallpapers+1]
    elseif k==keys.three then s.animations=(s.animations=="true" and "false" or "true")
    elseif k==keys.four then term.setCursorPos(3,17); term.clearLine(); write("New computer name: "); local n=read(); if n~="" then os.setComputerLabel(n); s.name=n end
    elseif k==keys.five then s.clock24=(s.clock24=="true" and "false" or "true")
    elseif k==keys.six then s.showClock=(s.showClock=="true" and "false" or "true")
    elseif k==keys.seven then save(); ui.message("Settings","Changes saved.")
    elseif k==keys.eight then s=config.defaults; save(); ui.message("Settings","Settings restored to defaults.")
    elseif k==keys.nine then shell.run("/apps/bookmarks.lua") end
  end
end
