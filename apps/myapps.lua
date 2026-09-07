local ui = dofile("/sys/ui.lua")
local config = dofile("/lib/config.lua")

local ROOT = "/suslix/user_apps"
local INDEX = ROOT .. "/index.cfg"

local builtin = {
  {"Terminal", "/apps/terminal.lua"}, {"File Manager", "/apps/fileman.lua"},
  {"Package Center", "/apps/packages.lua"}, {"Network", "/apps/network.lua"},
  {"Rednet", "/apps/rednet.lua"}, {"Devices", "/apps/devices2.lua"},
  {"System Monitor", "/apps/monitor.lua"}, {"System Info", "/apps/sysinfo.lua"},
  {"Calculator", "/apps/calc.lua"}, {"Clock", "/apps/clock.lua"},
  {"Processes", "/apps/procman.lua"}, {"Turtle Control", "/apps/turtle.lua"},
  {"Help", "/apps/help.lua"}, {"Settings", "/apps/settings.lua"},
  {"My Apps", "/apps/myapps.lua"},
}

local function ensure()
  if not fs.exists("/suslix") then fs.makeDir("/suslix") end
  if not fs.exists(ROOT) then fs.makeDir(ROOT) end
end

local function loadUser()
  ensure()
  local out = {}
  if not fs.exists(INDEX) then return out end
  local f = fs.open(INDEX, "r")
  if not f then return out end
  for line in (f.readAll() or ""):gmatch("[^\n]+") do
    local name,path = line:match("^(.-)\t(.+)$")
    if name and path and fs.exists(path) then table.insert(out,{name,path}) end
  end
  f.close()
  return out
end

local function saveUser(list)
  ensure()
  local f = fs.open(INDEX, "w")
  if not f then return false end
  for _,a in ipairs(list) do f.writeLine(a[1]:gsub("[\r\n\t]"," ") .. "\t" .. a[2]) end
  f.close()
  return true
end

local function copyApp(source, name)
  if not fs.exists(source) then return false, "File not found." end
  if fs.isDir(source) then return false, "Choose a Lua program file, not a folder." end
  if not name or name == "" then return false, "App name is required." end
  if not source:match("%.lua$") then return false, "The app must be a .lua file." end
  local safe = name:gsub("[^%w_%- ]", ""):sub(1,24)
  if safe == "" then safe = "My App" end
  local filename = safe:gsub("%s+", "_") .. ".lua"
  local dest = fs.combine(ROOT, filename)
  local f = fs.open(source,"rb"); local data=f.readAll(); f.close()
  local o = fs.open(dest,"wb"); o.write(data); o.close()
  return true, dest, safe
end

local function installUser()
  term.clear(); term.setCursorPos(1,1)
  print("Add an application")
  print()
  print("1. Copy a Lua file from this computer")
  print("2. Install a Lua file from a URL")
  print("Q. Back")
  local e,k = os.pullEvent("key")
  if e ~= "key" then return end
  if k == keys.q then return end
  local source
  if k == keys.one then
    print(); write("Path to .lua file: "); source = read()
  elseif k == keys.two then
    if not http then ui.message("HTTP disabled", "Enable the HTTP API in CC:Tweaked settings."); return end
    print(); write("URL of .lua file: "); local url = read()
    local ok,h = pcall(http.get,url)
    if not ok or not h then ui.message("Download failed", "Could not download that URL."); return end
    local data=h.readAll(); h.close()
    local tmp=ROOT.."/.download.lua"; local f=fs.open(tmp,"wb"); f.write(data); f.close(); source=tmp
  else return end
  print(); write("Name shown on desktop: "); local name=read()
  local ok,dest,finalName = copyApp(source,name)
  if source==ROOT.."/.download.lua" and fs.exists(source) then fs.delete(source) end
  if not ok then ui.message("Could not add app", dest); return end
  local list=loadUser(); table.insert(list,{finalName,dest}); saveUser(list)
  ui.message("App added", finalName.." is now available in My Apps.")
end

local function main()
  while true do
    local s=config.load(); local c=config.colors(s.theme); ui.clear(c.bg); ui.header("My Apps",c.surface,c.text)
    local list=loadUser(); local rows=#builtin+#list
    term.setTextColor(c.text)
    term.setCursorPos(3,3); term.write("Your applications")
    local max=math.max(1,math.min(rows,term.getSize()-7))
    for i=1,max do
      local item = builtin[i] or {list[i-#builtin][1],list[i-#builtin][2]}
      term.setCursorPos(3,i+4); term.write(string.format("%2d  %s",i,item[1]:sub(1,term.getSize()-8)))
    end
    term.setCursorPos(3,term.getSize()-2); term.setTextColor(c.accent); term.write("N  Add app     "); term.setTextColor(c.text); term.write("R  Refresh    Q  Back")
    local e,k=os.pullEvent()
    if e=='key' then
      if k==keys.q then return
      elseif k==keys.n then installUser()
      elseif k==keys.r then
      elseif k>=keys.one and k<=keys.nine then
        local n=k-keys.zero; local item=builtin[n] or list[n-#builtin]
        if item and fs.exists(item[2]) then shell.run(item[2]) end
      end
    elseif e=='mouse_click' or e=='monitor_touch' then
      local _,_,x,y = e=='mouse_click' and os.pullEvent('mouse_click') or {nil,nil}
    end
  end
end

main()
