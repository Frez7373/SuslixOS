local ui = dofile("/sys/ui.lua")
local config = dofile("/lib/config.lua")
local desktop = {
  {"Terminal", "/apps/terminal.lua", "CLI"},
  {"File Manager", "/apps/fileman.lua", "FILES"},
  {"Package Center", "/apps/packages.lua", "STORE"},
  {"Network Center", "/apps/network.lua", "NET"},
  {"Rednet Center", "/apps/rednet.lua", "REDNET"},
  {"Device Center", "/apps/devices2.lua", "DEV"},
  {"System Monitor", "/apps/monitor.lua", "MON"},
  {"System Info", "/apps/sysinfo.lua", "INFO"},
  {"Calculator", "/apps/calc.lua", "CALC"},
  {"Clock", "/apps/clock.lua", "TIME"},
  {"Process Manager", "/apps/procman.lua", "PROC"},
  {"Turtle Control", "/apps/turtle.lua", "TURTLE"},
  {"Help Center", "/apps/help.lua", "HELP"},
  {"Settings", "/apps/settings.lua", "SET"},
}

local function draw()
  local s=config.load(); local c=config.colors(s.theme); ui.clear(c.bg); ui.header("★ Favorites & Applications", c.surface)
  local w,h=term.getSize(); local cols=w>=70 and 3 or 2; local cellw=math.floor((w-2)/cols); local visible=math.min(#desktop, math.max(1, math.floor((h-5)/3)*cols))
  for i=1,visible do
    local app=desktop[i]; local col=(i-1)%cols; local row=math.floor((i-1)/cols); local x=2+col*cellw; local y=3+row*3
    ui.button(x,y,cellw-1,app[3],c.selected,c.text); term.setBackgroundColor(c.bg); term.setTextColor(c.text); term.setCursorPos(x,y+1); term.write(app[1]:sub(1,cellw-2))
  end
  ui.footer("Click an app • ENTER launches selected by number • Q back",c.panel,c.text)
end
while true do
  draw(); local e,a,x,y=os.pullEvent()
  if e=="key" then
    if a==keys.q then return end
    if a>=keys.one and a<=keys.nine then local n=a-keys.zero; if desktop[n] and fs.exists(desktop[n][2]) then shell.run(desktop[n][2]) end end
  elseif (e=="mouse_click" or e=="monitor_touch") and x and y then
    local w,_=term.getSize(); local cols=w>=70 and 3 or 2; local cellw=math.floor((w-2)/cols); if y>=3 then local col=math.floor((x-2)/cellw); local row=math.floor((y-3)/3); local n=row*cols+col+1; if desktop[n] and x>=2+col*cellw and x<2+(col+1)*cellw and y<=4+row*3 then shell.run(desktop[n][2]); end end
  end
end
