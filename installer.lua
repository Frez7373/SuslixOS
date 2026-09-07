local BASE = "https://raw.githubusercontent.com/Frez7373/SuslixOS/main/"

local files = {
  {"startup.lua", "/startup.lua"},
  {"sys/boot.lua", "/sys/boot.lua"},
  {"sys/ui.lua", "/sys/ui.lua"},
  {"apps/desktop.lua", "/apps/desktop.lua"},
  {"apps/fileman.lua", "/apps/fileman.lua"},
  {"apps/packages.lua", "/apps/packages.lua"},
  {"apps/settings.lua", "/apps/settings.lua"},
  {"apps/network.lua", "/apps/network.lua"},
  {"apps/monitor.lua", "/apps/monitor.lua"},
  {"lib/suslix.lua", "/lib/suslix.lua"},
  {"README.md", "/SuslixOS-README.md"}
}

local function say(text, c)
  term.setTextColor(c or colors.white)
  print(text)
end

term.clear()
term.setCursorPos(1,1)
say("SuslixOS installer", colors.lime)
say("Opus-inspired CC:Tweaked desktop system", colors.lightGray)
print()
say("WARNING: startup.lua will be replaced.", colors.yellow)
say("Install only on a computer you want to convert to SuslixOS.", colors.yellow)
print()
write("Continue? [y/N]: ")
local answer = read()
if answer:lower() ~= "y" then return end

local function download(url, path)
  local h, err = http.get(url, nil, true)
  if not h then return false, tostring(err) end
  local data = h.readAll()
  h.close()
  local dir = fs.getDir(path)
  if dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end
  local f = fs.open(path, "wb")
  if not f then return false, "cannot open " .. path end
  f.write(data)
  f.close()
  return true
end

if not http then
  error("HTTP API is disabled. Enable http in CC:Tweaked settings.")
end

for i, item in ipairs(files) do
  local src, dst = item[1], item[2]
  write(string.format("[%02d/%02d] %s ... ", i, #files, src))
  local ok, err = download(BASE .. src, dst)
  if ok then
    term.setTextColor(colors.lime)
    print("OK")
  else
    term.setTextColor(colors.red)
    print("FAILED: " .. err)
    error("Installation failed while downloading " .. src)
  end
end

if not fs.exists("/suslix") then fs.makeDir("/suslix") end
local f = fs.open("/suslix/version", "w")
f.write("1.0.0")
f.close()

term.setTextColor(colors.lime)
print("\nSuslixOS installed successfully.")
term.setTextColor(colors.white)
print("Rebooting...")
os.reboot()
