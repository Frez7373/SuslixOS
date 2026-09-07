local ui = dofile("/sys/ui.lua")
local file="/suslix/settings.txt"

local settings={theme="blue",startup="desktop",name="SuslixOS Computer"}
if fs.exists(file) then
  local f=fs.open(file,"r")
  for line in f.readAll():gmatch("[^\n]+") do
    local k,v=line:match("^([^=]+)=(.*)$")
    if k and v then settings[k]=v end
  end
  f.close()
end

local function save()
  local f=fs.open(file,"w")
  for k,v in pairs(settings) do f.writeLine(k.."="..v) end
  f.close()
end

while true do
  ui.clear(colors.black)
  ui.header("Settings")
  term.setTextColor(colors.white)
  term.setCursorPos(2,3); term.write("Computer name: "..settings.name)
  term.setCursorPos(2,4); term.write("Theme: "..settings.theme)
  term.setCursorPos(2,5); term.write("Startup: "..settings.startup)
  term.setCursorPos(2,7); term.write("1. Rename computer")
  term.setCursorPos(2,8); term.write("2. Toggle theme")
  term.setCursorPos(2,9); term.write("3. Save settings")
  ui.footer("Press 1-3   Q to exit")
  local e,k=os.pullEvent()
  if e=="key" then
    if k==keys.q then return
    elseif k==keys.one then
      term.setCursorPos(2,11); term.write("New name: "); settings.name=read()
    elseif k==keys.two then settings.theme=(settings.theme=="blue" and "green" or "blue")
    elseif k==keys.three then save(); ui.message("Settings","Saved successfully.") end
  end
end
