local BASE = "https://raw.githubusercontent.com/Frez7373/SuslixOS/main/"

local files = {
  {"startup.lua", "/startup.lua"},
  {"sys/boot.lua", "/sys/boot.lua"},
  {"sys/ui.lua", "/sys/ui.lua"},
  {"sys/recovery.lua", "/sys/recovery.lua"},
  {"apps/desktop.lua", "/apps/desktop.lua"},
  {"apps/terminal.lua", "/apps/terminal.lua"},
  {"apps/fileman.lua", "/apps/fileman.lua"},
  {"apps/packages.lua", "/apps/packages.lua"},
  {"apps/settings.lua", "/apps/settings.lua"},
  {"apps/network.lua", "/apps/network.lua"},
  {"apps/devices.lua", "/apps/devices.lua"},
  {"apps/monitor.lua", "/apps/monitor.lua"},
  {"lib/suslix.lua", "/lib/suslix.lua"},
}

local function say(text, c)
  term.setTextColor(c or colors.white)
  print(text)
end

term.clear(); term.setCursorPos(1,1)
say("SUSLIXOS INSTALLER", colors.lime)
say("Opus-inspired desktop system for CC:Tweaked", colors.lightGray)
print()
if not http then error("HTTP API is disabled. Enable the CC:Tweaked HTTP API first.") end

if not fs.exists("/suslix") then fs.makeDir("/suslix") end
if not fs.exists("/suslix/backup") then fs.makeDir("/suslix/backup") end

if fs.exists("/startup.lua") and not fs.exists("/suslix/backup/startup.lua") then
  fs.copy("/startup.lua","/suslix/backup/startup.lua")
  say("Saved original startup.lua to /suslix/backup/startup.lua", colors.yellow)
end

write("Install/update SuslixOS? [y/N]: ")
if read():lower() ~= "y" then return end

local function download(url, path)
  local h, err = http.get(url, nil, true)
  if not h then return false, tostring(err) end
  local data = h.readAll(); h.close()
  local dir = fs.getDir(path)
  if dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end
  local f = fs.open(path, "wb")
  if not f then return false, "cannot write " .. path end
  f.write(data); f.close()
  return true
end

for i,item in ipairs(files) do
  local src,dst=item[1],item[2]
  write(string.format("[%02d/%02d] %-26s ",i,#files,src))
  local ok,err=download(BASE..src,dst)
  if ok then say("OK",colors.lime) else say("FAILED: "..err,colors.red); return end
end

local f=fs.open("/suslix/version","w"); f.write("1.0.0-alpha"); f.close()
say("\nInstallation complete.",colors.lime)
say("Recovery: run /sys/recovery.lua if you need to restore CraftOS.",colors.lightGray)
say("Rebooting...",colors.white)
sleep(1)
os.reboot()
