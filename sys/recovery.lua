term.setBackgroundColor(colors.black)
term.setTextColor(colors.lime)
term.clear(); term.setCursorPos(1,1)
print("SUSLIXOS RECOVERY")
print()
print("1. Restore previous startup.lua")
print("2. Reinstall SuslixOS")
print("3. Boot CraftOS shell")
print("Q. Exit")
local _,k=os.pullEvent("key")
if k==keys.one then
  if fs.exists("/suslix/backup/startup.lua") then
    fs.copy("/suslix/backup/startup.lua","/startup.lua")
    print("Startup restored. Rebooting...")
    sleep(1); os.reboot()
  else print("No startup backup found."); sleep(2) end
elseif k==keys.two then
  shell.run("/installer.lua")
elseif k==keys.three then
  shell.run("shell")
end
