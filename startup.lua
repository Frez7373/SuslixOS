-- SuslixOS startup
local boot = "/sys/boot.lua"
if fs.exists(boot) then
  shell.run(boot)
else
  term.clear()
  term.setCursorPos(1,1)
  print("SuslixOS: boot files are missing.")
  print("Run the installer again.")
end
