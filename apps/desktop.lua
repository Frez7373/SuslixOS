local ui=dofile('/sys/ui.lua')
local config=dofile('/lib/config.lua')
local builtin={{'Terminal','/apps/terminal.lua','TERM'},{'Files','/apps/fileman.lua','FILES'},{'Apps','/apps/myapps.lua','APPS'},{'Network','/apps/network.lua','NET'},{'Devices','/apps/devices2.lua','DEV'},{'Monitor','/apps/monitor.lua','MON'},{'Calculator','/apps/calc.lua','CALC'},{'Clock','/apps/clock.lua','TIME'},{'Help','/apps/help.lua','HELP'},{'Settings','/apps/settings.lua','SET'},{'Task Manager','/apps/taskman.lua','TASK'}}
local function loadUser() local out={}; local p='/suslix/user_apps/index.cfg'; if not fs.exists(p) then return out end; local f=fs.open(p,'r'); if not f then return out end; for line in (f.readAll() or ''):gmatch('[^\n]+') do line=line:gsub('\r',''); local n,path=line:match('^(.-)\t(.+)$'); if n and path and fs.exists(path) then table.insert(out,{n,path,'APP'}) end end; f.close(); return out end
local function allApps() local a={}; for _,v in ipairs(builtin) do table.insert(a,v) end; for _,v in ipairs(loadUser()) do table.insert(a,v) end; return a end
local function run(p,title) if fs.exists(p) then if multishell and multishell.launch then local tab=multishell.launch({},p); if title then multishell.setTitle(title,tab) end; multishell.setFocus(tab) else shell.run(p) end else ui.message('App unavailable','This shortcut points to a missing program.') end end
local function clock(s) if s.clock24=='true' then return os.date('%H:%M') else return os.date('%I:%M %p'):gsub('^0','') end end
local function tasks(c,w,dock)
 if not multishell then return end
 local n=multishell.getCount(); local x=2
 for i=1,n do local title=multishell.getTitle(i) or ('Window '..i); local bw=math.min(18,math.max(10,#title+2)); if x+bw>w-12 then break end; ui.button(x,dock,bw,title, i==multishell.getCurrent(),c.panel,c.text); x=x+bw+1 end
end
while true do
 local s=config.load(); local c=config.colors(s.theme); local apps=allApps(); local w,h=term.getSize(); ui.clear(c.bg)
 term.setBackgroundColor(c.surface); term.setTextColor(c.text); term.setCursorPos(1,1); term.write(string.rep(' ',w)); term.setCursorPos(2,1); term.write('SuslixOS'); term.setTextColor(c.muted); term.setCursorPos(12,1); term.write('Home'); if s.showClock=='true' then term.setTextColor(c.text); term.setCursorPos(math.max(1,w-12),1); term.write(clock(s)) end
 local cols=w>=58 and 4 or (w>=42 and 3 or 2); local cell=math.max(14,math.floor((w-2)/cols)); local rows=math.max(1,math.floor((h-6)/3)); local visible=math.min(#apps,rows*cols)
 for i=1,visible do local a=apps[i]; local col=(i-1)%cols; local row=math.floor((i-1)/cols); local x=2+col*cell; local y=3+row*3; term.setBackgroundColor(c.surface); term.setTextColor(c.text); term.setCursorPos(x,y); term.write(string.rep(' ',math.min(cell-1,11))); term.setCursorPos(x+1,y); term.write(a[3]:sub(1,math.min(#a[3],cell-3))); term.setBackgroundColor(c.bg); term.setTextColor(c.text); term.setCursorPos(x,y+1); term.write(a[1]:sub(1,math.max(1,cell-2))) end
 local dock=h-2; term.setBackgroundColor(c.panel); term.setTextColor(c.text); term.setCursorPos(1,dock); term.write(string.rep(' ',w)); ui.button(2,dock,9,'APPS',false,c.panel,c.text); ui.button(13,dock,9,'MY APPS',false,c.panel,c.text); ui.button(24,dock,10,'TASKS',false,c.panel,c.text); ui.button(36,dock,10,'SETTINGS',false,c.panel,c.text); ui.button(math.max(1,w-8),dock,7,'POWER',false,c.panel,c.text); tasks(c,w,dock)
 local e,a,x,y=os.pullEvent()
 if e=='key' then
  if a==keys.f1 then run('/apps/help.lua','Help') elseif a==keys.f2 then run('/apps/terminal.lua','Terminal') elseif a==keys.f3 then run('/apps/fileman.lua','Files') elseif a==keys.f4 then run('/apps/network.lua','Network') elseif a==keys.f5 then run('/apps/myapps.lua','My Apps') elseif a==keys.f6 then run('/apps/settings.lua','Settings') elseif a==keys.f7 then run('/apps/taskman.lua','Task Manager') elseif a==keys.f8 then run('/apps/bookmarks.lua','Favorites') elseif a>=keys.one and a<=keys.nine then local n=a-keys.zero; if apps[n] then run(apps[n][2],apps[n][1]) end end
 elseif (e=='mouse_click' or e=='monitor_touch') and x and y then
  if y==dock then if x>=2 and x<=10 then run('/apps/myapps.lua','My Apps') elseif x>=13 and x<=21 then run('/apps/myapps.lua','My Apps') elseif x>=24 and x<=33 then run('/apps/taskman.lua','Task Manager') elseif x>=36 and x<=45 then run('/apps/settings.lua','Settings') elseif x>=w-8 then os.shutdown() end
  elseif y>=3 then local col=math.floor((x-2)/cell); local row=math.floor((y-3)/3); local n=row*cols+col+1; if n<=visible then run(apps[n][2],apps[n][1]) end end end
end
