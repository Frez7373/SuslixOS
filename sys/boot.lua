local ui = dofile("/sys/ui.lua")
local core = dofile("/lib/suslix.lua")

term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)

local w,h = term.getSize()
core.center("SUSLIXOS", math.max(2, math.floor(h/2)-2), colors.lime)
core.center("Starting system...", math.max(3, math.floor(h/2)), colors.lightGray)
sleep(0.4)

local checks = {
  {"Filesystem", fs.getDrive("/home") ~= nil},
  {"Display", w >= 20 and h >= 8},
  {"HTTP API", http ~= nil},
  {"Peripheral API", peripheral ~= nil},
}
local y = math.max(4, math.floor(h/2)+2)
for i,c in ipairs(checks) do
  term.setCursorPos(math.max(2,math.floor(w/2)-12), y+i-1)
  term.setTextColor(c[2] and colors.lime or colors.yellow)
  term.write((c[2] and "[ OK ] " or "[ -- ] ") .. c[1])
  sleep(0.12)
end
sleep(0.2)
shell.run("/apps/desktop.lua")
