local ui=dofile("/sys/ui.lua")

local function pick(t)
  local names={}
  for _,n in ipairs(peripheral.getNames()) do
    if peripheral.getType(n)==t then table.insert(names,n) end
  end
  return names
end

while true do
  ui.clear(colors.black); ui.header("Device Center")
  term.setTextColor(colors.white)
  term.setCursorPos(2,3); term.write("1. Printer")
  term.setCursorPos(2,4); term.write("2. Speaker")
  term.setCursorPos(2,5); term.write("3. Redstone")
  term.setCursorPos(2,6); term.write("4. Peripheral list")
  term.setCursorPos(2,7); term.write("Q. Back")
  ui.footer("Peripheral control")
  local e,k=os.pullEvent()
  if e=="key" then
    if k==keys.q then return
    elseif k==keys.one then
      local p=pick("printer")[1]
      if not p then ui.message("Printer","No printer found.") else
        local d=peripheral.wrap(p)
        d.newPage(); d.write("SuslixOS test page")
        d.setPageTitle("SuslixOS")
        d.endPage(); ui.message("Printer","Test page sent to "..p)
      end
    elseif k==keys.two then
      local p=pick("speaker")[1]
      if not p then ui.message("Speaker","No speaker found.") else
        peripheral.call(p,"playNote","harp",1,12); ui.message("Speaker","Test note played on "..p)
      end
    elseif k==keys.three then
      ui.clear(colors.black); ui.header("Redstone")
      for i,side in ipairs({"top","bottom","left","right","front","back"}) do
        term.setCursorPos(2,i+2)
        term.write(side..": "..redstone.getOutput(side))
      end
      term.setCursorPos(2,10); term.write("Press a key to return")
      os.pullEvent("key")
    elseif k==keys.four then
      ui.clear(colors.black); ui.header("Peripherals")
      for i,n in ipairs(peripheral.getNames()) do
        term.setCursorPos(2,i+2); term.write(n.." : "..tostring(peripheral.getType(n)))
      end
      term.setCursorPos(2,term.getSize()); term.write("Press a key")
      os.pullEvent("key")
    end
  end
end
