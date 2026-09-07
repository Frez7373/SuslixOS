local ui=dofile('/sys/ui.lua')
local core=dofile('/lib/suslix.lua')
local config=dofile('/lib/config.lua')

local apps={
 {'Terminal','/apps/terminal.lua','CLI'}, {'File Manager','/apps/fileman.lua','FILE'}, {'Package Center','/apps/packages.lua','STORE'},
 {'Network Center','/apps/network.lua','NET'}, {'Rednet Center','/apps/rednet.lua','RED'}, {'Device Center','/apps/devices2.lua','DEV'},
 {'System Monitor','/apps/monitor.lua','MON'}, {'System Info','/apps/sysinfo.lua','INFO'}, {'Calculator','/apps/calc.lua','CALC'},
 {'Clock','/apps/clock.lua','TIME'}, {'Process Manager','/apps/procman.lua','PROC'}, {'Turtle Control','/apps/turtle.lua','TURTLE'},
 {'Help Center','/apps/help.lua','HELP'}, {'Settings','/apps/settings.lua','SET'}
}
local s=config.load(); local menu=false

local function reload() s=config.load() end
local function run(path) if fs.exists(path) then shell.run(path) else ui.message('SuslixOS','Application missing:\n'..path) end end
local function paintLine(y,bg,fg) local w=term.getSize(); term.setBackgroundColor(bg); term.setTextColor(fg); term.setCursorPos(1,y); term.write(string.rep(' ',w)) end
local function clockText()
 if s.clock24=='true' then return os.date('%H:%M') end
 return os.date('%I:%M %p'):gsub('^0','')
end

local function draw()
 reload(); local c=config.colors(s.theme); local w,h=term.getSize(); ui.clear(c.bg)
 if s.wallpaper=='grid' then
  term.setBackgroundColor(c.bg); term.setTextColor(c.muted)
  for y=2,h-3,2 do term.setCursorPos(1,y); term.write(string.rep('.',w)) end
 elseif s.wallpaper=='lines' then
  term.setBackgroundColor(c.bg); term.setTextColor(c.muted)
  for x=8,w,8 do for y=2,h-3 do term.setCursorPos(x,y); term.write('|') end end
 end
 paintLine(1,c.surface,c.text); term.setCursorPos(2,1); term.write('SUSLIXOS'); term.setTextColor(c.muted); term.setCursorPos(11,1); term.write('Desktop')
 if s.showClock=='true' then term.setCursorPos(math.max(1,w-12),1); term.setTextColor(c.text); term.write(clockText()) end

 local cols=w>=70 and 4 or 3; local cellw=math.max(14,math.floor((w-2)/cols)); local maxRows=math.max(1,math.floor((h-6)/4)); local maxApps=math.min(#apps,maxRows*cols)
 for i=1,maxApps do
  local a=apps[i]; local col=(i-1)%cols; local row=math.floor((i-1)/cols); local x=2+col*cellw; local y=3+row*4
  term.setBackgroundColor(c.surface); term.setTextColor(c.text); term.setCursorPos(x,y); term.write(string.rep(' ',math.min(cellw-1,12)))
  term.setCursorPos(x+1,y); term.write(a[3]:sub(1,math.min(#a[3],cellw-3)))
  term.setBackgroundColor(c.bg); term.setTextColor(c.text); term.setCursorPos(x,y+1); term.write(a[1]:sub(1,cellw-2))
 end

 local dockY=h-2; paintLine(dockY,c.panel,c.text)
 ui.button(2,dockY,9,'START',menu,c.surface,c.text); ui.button(13,dockY,8,'FAV',false,c.panel,c.text); ui.button(23,dockY,8,'NET',false,c.panel,c.text); ui.button(33,dockY,8,'INFO',false,c.panel,c.text); ui.button(43,dockY,10,'SETTINGS',false,c.panel,c.text)
 if menu then
  local mw=math.min(42,w-2); local mh=math.min(h-5,#apps+3); local x=2; local y=dockY-mh; ui.window(x,y,mw,mh,'Applications')
  local shown=math.min(#apps,mh-3)
  for i=1,shown do term.setBackgroundColor(c.panel); term.setTextColor(c.text); term.setCursorPos(x+2,y+i); term.write(string.format('%2d  %s',i,apps[i][1])) end
 end
end

while true do
 draw(); local e,a,x,y=os.pullEvent()
 if e=='terminate' then return end
 if e=='key' then
  if a==keys.leftAlt then menu=not menu
  elseif a==keys.f1 then run('/apps/help.lua') elseif a==keys.f2 then run('/apps/terminal.lua') elseif a==keys.f3 then run('/apps/fileman.lua')
  elseif a==keys.f4 then run('/apps/network.lua') elseif a==keys.f5 then run('/apps/packages.lua') elseif a==keys.f6 then run('/apps/devices2.lua')
  elseif a==keys.f7 then run('/apps/settings.lua') elseif a==keys.f8 then run('/apps/bookmarks.lua')
  elseif a>=keys.one and a<=keys.nine and menu then local n=a-keys.zero; if apps[n] then menu=false; run(apps[n][2]) end
 end
 elseif (e=='mouse_click' or e=='monitor_touch') and x and y then
  local w,h=term.getSize()
  if y==h-2 then
   if x>=2 and x<=10 then menu=not menu elseif x>=13 and x<=20 then menu=false;run('/apps/bookmarks.lua') elseif x>=23 and x<=30 then menu=false;run('/apps/network.lua') elseif x>=33 and x<=40 then menu=false;run('/apps/sysinfo.lua') elseif x>=43 and x<=52 then menu=false;run('/apps/settings.lua') end
  elseif menu then local mh=math.min(h-5,#apps+3); local top=h-2-mh; local n=y-top; if n>=1 and n<=math.min(#apps,mh-3) then menu=false;run(apps[n][2]) end
  else
   local cols=w>=70 and 4 or 3; local cellw=math.max(14,math.floor((w-2)/cols)); local row=math.floor((y-3)/4); local col=math.floor((x-2)/cellw); local idx=row*cols+col+1; local maxApps=math.min(#apps,math.max(1,math.floor((h-6)/4))*cols)
   if y>=3 and idx<=maxApps and x>=2+col*cellw then run(apps[idx][2]) end
  end
 end
end
