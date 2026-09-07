local ui=dofile("/sys/ui.lua")
ui.clear(colors.black)
ui.header("Suslix Terminal")
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.setCursorPos(2,3)
print("SuslixOS shell. Type 'exit' to return to desktop.")
print("Built-in commands from CraftOS remain available.")
print()
while true do
  term.setTextColor(colors.lime)
  write("suslix$ ")
  term.setTextColor(colors.white)
  local cmd=read()
  if cmd=="exit" then return end
  if cmd~="" then
    local ok,err=pcall(function() shell.run(cmd) end)
    if not ok then printError(err) end
  end
end
