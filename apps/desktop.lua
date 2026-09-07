local ui = dofile("/sys/ui.lua")
local core = dofile("/lib/suslix.lua")

local function runApp(path)
  if fs.exists(path) then
    shell.run(path)
  else
    ui.message("SuslixOS", "Application missing:\n" .. path)
  end
end

local function draw(startOpen)
  ui.clear(colors.black)
  local w,h = term.getSize()
  term.setBackgroundColor(colors.blue)
  for y=1,h-2 do
    term.setCursorPos(1,y)
    term.write(string.rep(" ",w))
  end
  core.center("SUSLIXOS", math.max(2,math.floor(h/2)-2), colors.white)
  core.center("Opus-inspired desktop for CC:Tweaked", math.max(3,math.floor(h/2)), colors.lightBlue)
  core.center("F2 Terminal   F3 Files   F4 Network   F5 Packages   F6 Devices", math.max(5,math.floor(h/2)+2), colors.lightGray)

  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.setCursorPos(1,h-1)
  term.write(string.rep(" ",w))
  ui.button(2,h-1,10,"START",startOpen)
  ui.button(14,h-1,8,"FILES",false)
  ui.button(24,h-1,8,"NET",false)
  ui.button(34,h-1,10,"PACKAGES",false)
  ui.button(46,h-1,8,"MONITOR",false)
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.setCursorPos(math.max(1,w-9),h-1)
  term.write(os.date("%H:%M"))

  if startOpen then
    local menuW = math.min(40,w-2)
    local items = {
      {"Terminal","/apps/terminal.lua"},
      {"File Manager","/apps/fileman.lua"},
      {"Package Center","/apps/packages.lua"},
      {"Network Center","/apps/network.lua"},
      {"Device Center","/apps/devices.lua"},
      {"System Monitor","/apps/monitor.lua"},
      {"Settings","/apps/settings.lua"},
    }
    local menuH=#items+3
    local x=2; local y=h-menuH-2
    ui.window(x,y,menuW,menuH,"SuslixOS")
    for i,item in ipairs(items) do
      term.setBackgroundColor(colors.lightGray)
      term.setTextColor(colors.black)
      term.setCursorPos(x+2,y+i)
      term.write(i..". "..item[1])
    end
    return {x=x,y=y,w=menuW,items=items}
  end
end

local startOpen=false
while true do
  local menu=draw(startOpen)
  local e,a,x,y=os.pullEvent()
  if e=="terminate" then return end
  if e=="key" then
    if a==keys.leftAlt then startOpen=not startOpen
    elseif a==keys.f2 then runApp("/apps/terminal.lua")
    elseif a==keys.f3 then runApp("/apps/fileman.lua")
    elseif a==keys.f4 then runApp("/apps/network.lua")
    elseif a==keys.f5 then runApp("/apps/packages.lua")
    elseif a==keys.f6 then runApp("/apps/devices.lua") end
  elseif (e=="mouse_click" or e=="monitor_touch") and y then
    local _,h=term.getSize()
    if y==h-1 then
      if x>=2 and x<=11 then startOpen=not startOpen
      elseif x>=14 and x<=21 then startOpen=false; runApp("/apps/fileman.lua")
      elseif x>=24 and x<=31 then startOpen=false; runApp("/apps/network.lua")
      elseif x>=34 and x<=43 then startOpen=false; runApp("/apps/packages.lua")
      elseif x>=46 and x<=53 then startOpen=false; runApp("/apps/monitor.lua") end
    elseif startOpen and menu and x>=menu.x+2 and x<=menu.x+menu.w-2 then
      for i,item in ipairs(menu.items) do
        if y==menu.y+i then startOpen=false; runApp(item[2]); break end
      end
    end
  end
end
