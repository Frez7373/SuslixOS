local ui = dofile("/sys/ui.lua")
local config = dofile("/lib/config.lua")

local ROOT = "/suslix/user_apps"
local INDEX = ROOT .. "/index.cfg"
local builtin = {
 {"Terminal","/apps/terminal.lua"},{"File Manager","/apps/fileman.lua"},{"Package Center","/apps/packages.lua"},
 {"Network","/apps/network.lua"},{"Rednet","/apps/rednet.lua"},{"Devices","/apps/devices2.lua"},{"System Monitor","/apps/monitor.lua"},
 {"System Info","/apps/sysinfo.lua"},{"Calculator","/apps/calc.lua"},{"Clock","/apps/clock.lua"},{"Processes","/apps/procman.lua"},
 {"Turtle Control","/apps/turtle.lua"},{"Help","/apps/help.lua"},{"Settings","/apps/settings.lua"},{"My Apps","/apps/myapps.lua"},
}

local function ensure()
 if not fs.exists("/suslix") then fs.makeDir("/suslix") end
 if not fs.exists(ROOT) then fs.makeDir(ROOT) end
end
local function loadUser()
 ensure(); local out={}
 if not fs.exists(INDEX) then return out end
 local f=fs.open(INDEX,"r"); if not f then return out end
 for line in (f.readAll() or ""):gmatch("[^\n]+") do
  line=line:gsub("\r",""); local n,p=line:match("^(.-)\t(.+)$")
  if n and p and fs.exists(p) then table.insert(out,{n,p}) end
 end
 f.close(); return out
end
local function saveUser(list)
 ensure(); local f=fs.open(INDEX,"w"); if not f then return false end
 for _,a in ipairs(list) do f.writeLine(a[1]:gsub("[\r\n\t]"," ").."\t"..a[2]) end
 f.close(); return true
end

local function addApp()
 ui.clear(colors.black); ui.header("Add an application",colors.blue,colors.white)
 print(); print("Where is the program?"); print(); print("1  On this computer"); print("2  On the Internet"); print("Q  Cancel")
 local _,k=os.pullEvent("key"); if k==keys.q then return end
 local source
 if k==keys.one then
  print(); write("Path to .lua file: "); source=read()
 elseif k==keys.two then
  if not http then ui.message("HTTP is disabled","Enable HTTP in CC:Tweaked settings first."); return end
  print(); write("URL of .lua file: "); local url=read()
  local ok,h=pcall(http.get,url)
  if not ok or not h then ui.message("Download failed","The URL could not be downloaded."); return end
  local data=h.readAll() or ""; h.close(); if data=="" then ui.message("Download failed","The downloaded file was empty."); return end
  source=ROOT.."/.download.lua"; local f=fs.open(source,"wb"); f.write(data); f.close()
 else return end
 if not source or source=="" or not fs.exists(source) or fs.isDir(source) or not source:lower():match("%.lua$") then ui.message("Could not add app","Please choose a Lua program file (.lua)."); return end
 print(); write("Name for this app: "); local name=read(); if name=="" then name="My Application" end
 local safe=name:gsub("[^%w_%- ]",""):gsub("%s+","_"):sub(1,24); if safe=="" then safe="My_App" end
 local dest=fs.combine(ROOT,safe..".lua")
 local f=fs.open(source,"rb"); local data=f.readAll(); f.close(); local o=fs.open(dest,"wb"); if not o then ui.message("Could not add app","Cannot create the application file."); return end
 o.write(data); o.close(); if source==ROOT.."/.download.lua" and fs.exists(source) then fs.delete(source) end
 local list=loadUser(); table.insert(list,{name,dest}); saveUser(list); ui.message("Application added",name.." is now in My Apps and can be pinned to the desktop.")
end

while true do
 local s=config.load(); local c=config.colors(s.theme); ui.clear(c.bg); ui.header("My Apps",c.surface,c.text)
 local list=loadUser(); local w,h=term.getSize(); local total=#builtin+#list; local visible=math.min(total,math.max(1,h-7))
 term.setTextColor(c.muted); term.setCursorPos(3,3); term.write("Everything you can launch")
 term.setTextColor(c.text)
 for i=1,visible do local a=builtin[i] or list[i-#builtin]; term.setCursorPos(3,i+4); term.write(string.format("%2d  %s",i,a[1]:sub(1,math.max(1,w-8)))) end
 term.setTextColor(c.accent); term.setCursorPos(3,h-2); term.write("N Add app"); term.setTextColor(c.text); term.write("    Number Run    Q Back")
 local e,k=os.pullEvent()
 if e=="key" then
  if k==keys.q then return elseif k==keys.n then addApp()
  elseif k>=keys.one and k<=keys.nine then local n=k-keys.zero; local a=builtin[n] or list[n-#builtin]; if a and fs.exists(a[2]) then shell.run(a[2]) end end
 end
end
