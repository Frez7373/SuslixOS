local ui=dofile("/sys/ui.lua")

local pkgs={
  {"Text Editor","builtin",true},
  {"System Monitor","/apps/monitor.lua",true},
  {"Network Center","/apps/network.lua",true},
  {"File Manager","/apps/fileman.lua",true},
  {"Device Center","/apps/devices.lua",true},
  {"Basalt 2 UI","https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua",false},
  {"Pixelbox Lite","https://raw.githubusercontent.com/9551-Dev/pixelbox_lite/master/pixelbox_lite.lua",false},
  {"Artist storage","https://raw.githubusercontent.com/SquidDev-CC/artist/HEAD/installer.lua",false},
}

local function install(url)
  if not http then ui.message("Package Center","HTTP API is disabled.") return end
  local ok,err=pcall(function()
    shell.run("wget","run",url)
  end)
  if not ok then ui.message("Package Center","Install failed:\n"..tostring(err)) end
end

while true do
  ui.clear(colors.black)
  ui.header("Suslix Package Center")
  for i,p in ipairs(pkgs) do
    term.setTextColor(p[3] and colors.lime or colors.lightBlue)
    term.setCursorPos(2,i+2)
    term.write(i..". "..p[1]..(p[3] and " [built-in]" or " [open source]"))
  end
  ui.footer("1-8 install/run   Q back")
  local e,k=os.pullEvent()
  if e=="key" then
    if k==keys.q then return end
    local idx=nil
    if k>=keys.one and k<=keys.eight then idx=k-keys.zero end
    if idx and pkgs[idx] then
      local p=pkgs[idx]
      if p[3] then shell.run(p[2]) else install(p[2]) end
    end
  end
end
