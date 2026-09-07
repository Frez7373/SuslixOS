local ui=dofile("/sys/ui.lua")

local repo="https://raw.githubusercontent.com/Frez7373/SuslixOS/main/"
local pkgs={
  {"Text Editor","/rom/programs/edit",true},
  {"System Monitor","/apps/monitor.lua",true},
  {"Network Center","/apps/network.lua",true},
  {"File Manager","/apps/fileman.lua",true},
  {"Basalt UI (external)","https://github.com/Pyroxenium/Basalt",false},
  {"Pixelbox Lite (external)","https://github.com/9551-Dev/pixelbox_lite",false},
  {"ecnet (external)","https://github.com/migeyel/ecnet",false},
  {"Telem (external)","https://github.com/SquidDev-CC/telem",false},
}

while true do
  ui.clear(colors.black)
  ui.header("Suslix Package Center")
  for i,p in ipairs(pkgs) do
    term.setTextColor(p[3] and colors.lime or colors.lightBlue)
    term.setCursorPos(2,i+2)
    term.write(i..". "..p[1]..(p[3] and " [built-in]" or " [catalog]"))
  end
  ui.footer("ENTER install/run   Q back")
  local e,k=os.pullEvent()
  if e=="key" then
    if k==keys.q then return end
    local idx=nil
    if k>=keys.one and k<=keys.eight then idx=k-keys.zero end
    if idx and pkgs[idx] then
      local p=pkgs[idx]
      if p[3] then shell.run(p[2])
      else ui.message("Package Center","Open the project page to install:\n"..p[2]) end
    end
  end
end
