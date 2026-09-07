local ui=dofile('/sys/ui.lua')
local core=dofile('/lib/suslix.lua')
local function runApp(path)
 if fs.exists(path) then shell.run(path) else ui.message('SuslixOS','Application missing:\n'..path) end
end
local apps={
 {'Terminal','/apps/terminal.lua'},{'File Manager','/apps/fileman.lua'},{'Package Center','/apps/packages.lua'},
 {'Network Center','/apps/network.lua'},{'Rednet Center','/apps/rednet.lua'},{'Device Center','/apps/devices2.lua'},
 {'System Monitor','/apps/monitor.lua'},{'System Info','/apps/sysinfo.lua'},{'Calculator','/apps/calc.lua'},
 {'Clock','/apps/clock.lua'},{'Process Manager','/apps/procman.lua'},{'Turtle Control','/apps/turtle.lua'},
 {'Settings','/apps/settings.lua'}
}
local startOpen=false
local function draw()
 ui.clear(colors.black); local w,h=term.getSize()
 term.setBackgroundColor(colors.blue); term.setTextColor(colors.white)
 for y=1,h-2 do term.setCursorPos(1,y); term.write(string.rep(' ',w)) end
 core.center('SUSLIXOS',math.max(2,math.floor(h/2)-3),colors.white)
 core.center('Opus-inspired desktop for CC:Tweaked',math.max(3,math.floor(h/2)-1),colors.lightBlue)
 core.center('Desktop • Network • Devices • Apps • Automation',math.max(4,math.floor(h/2)+1),colors.lightGray)
 term.setBackgroundColor(colors.gray); term.setCursorPos(1,h-1); term.write(string.rep(' ',w))
 ui.button(2,h-1,10,'START',startOpen); ui.button(14,h-1,8,'FILES'); ui.button(24,h-1,8,'NET'); ui.button(34,h-1,10,'APPS'); ui.button(46,h-1,8,'INFO')
 term.setBackgroundColor(colors.gray); term.setTextColor(colors.white); term.setCursorPos(math.max(1,w-8),h-1); term.write(os.date('%H:%M'))
 if startOpen then
  local mw=math.min(42,w-2); local shown=math.min(#apps,h-5); local mh=shown+3; local x=2; local y=h-mh-2
  ui.window(x,y,mw,mh,'SuslixOS Applications')
  for i=1,shown do term.setBackgroundColor(colors.lightGray); term.setTextColor(colors.black); term.setCursorPos(x+2,y+i); term.write(string.format('%2d. %s',i,apps[i][1])) end
  return {x=x,y=y,w=mw,shown=shown}
 end
end
while true do
 local menu=draw(); local e,a,x,y=os.pullEvent()
 if e=='terminate' then return end
 if e=='key' then
  if a==keys.leftAlt then startOpen=not startOpen
  elseif a==keys.f2 then runApp('/apps/terminal.lua') elseif a==keys.f3 then runApp('/apps/fileman.lua')
  elseif a==keys.f4 then runApp('/apps/network.lua') elseif a==keys.f5 then runApp('/apps/packages.lua')
  elseif a==keys.f6 then runApp('/apps/devices2.lua') end
 elseif (e=='mouse_click' or e=='monitor_touch') and x and y then
  local _,hh=term.getSize()
  if y==hh-1 then
   if x>=2 and x<=11 then startOpen=not startOpen elseif x>=14 and x<=21 then startOpen=false;runApp('/apps/fileman.lua')
   elseif x>=24 and x<=31 then startOpen=false;runApp('/apps/network.lua') elseif x>=34 and x<=43 then startOpen=false;runApp('/apps/packages.lua')
   elseif x>=46 and x<=53 then startOpen=false;runApp('/apps/sysinfo.lua') end
  elseif startOpen and menu and x>=menu.x+2 and x<=menu.x+menu.w-2 then
   local n=y-menu.y; if n>=1 and n<=menu.shown then startOpen=false;runApp(apps[n][2]) end
  end
 end
end
