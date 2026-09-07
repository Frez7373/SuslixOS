local ui=dofile("/sys/ui.lua")
local function countType(t)
  local n=0
  for _ in peripheral.find(t) do n=n+1 end
  return n
end
local function draw()
  ui.clear(colors.black)
  ui.header("System Monitor")
  local w,h=term.getSize()
  local id=os.getComputerID()
  local label=os.getComputerLabel() or "(none)"
  local free=fs.getFreeSpace("/")
  local total=fs.getCapacity("/")
  term.setTextColor(colors.white)
  local rows={
    "Computer ID: "..id,
    "Label: "..label,
    "Terminal: "..w.."x"..h,
    "Free space: "..tostring(free),
    "Total space: "..tostring(total),
    "Fuel (turtle): "..(turtle and tostring(turtle.getFuelLevel()) or "N/A"),
    "Modems: "..countType("modem"),
    "Printers: "..countType("printer"),
    "Speakers: "..countType("speaker"),
    "Monitors: "..countType("monitor"),
  }
  for i,row in ipairs(rows) do
    term.setCursorPos(2,i+2); term.write(row)
  end
  ui.footer("Q back")
end
while true do
  draw()
  local e,k=os.pullEvent()
  if e=="key" and k==keys.q then return end
end
