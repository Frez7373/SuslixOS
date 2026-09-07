local ui=dofile("/sys/ui.lua")

while true do
  ui.clear(colors.black)
  ui.header("Network Center")
  term.setCursorPos(2,3); term.setTextColor(colors.white)
  term.write("Wireless modem: ")
  local modems=peripheral.getNames()
  local wireless=nil
  for _,name in ipairs(modems) do
    if peripheral.getType(name)=="modem" then
      local m=peripheral.wrap(name)
      if m and m.isWireless and m.isWireless() then wireless=name break end
    end
  end
  term.write(wireless or "not found")
  term.setCursorPos(2,5); term.write("1. Scan peripherals")
  term.setCursorPos(2,6); term.write("2. Open rednet listener")
  term.setCursorPos(2,7); term.write("3. GPS locate")
  term.setCursorPos(2,8); term.write("Q. Back")
  ui.footer("CC:Tweaked networking toolkit")
  local e,k=os.pullEvent()
  if e=="key" then
    if k==keys.q then return
    elseif k==keys.one then
      ui.clear(colors.black); ui.header("Peripherals")
      for i,name in ipairs(peripheral.getNames()) do
        term.setCursorPos(2,i+2); term.write(name.." : "..tostring(peripheral.getType(name)))
      end
      ui.footer("Press any key")
      os.pullEvent("key")
    elseif k==keys.two then
      if not wireless then ui.message("Network","Wireless modem not found.") else
        rednet.open(wireless); ui.message("Network","Rednet opened on "..wireless) end
    elseif k==keys.three then
      if gps then
        local x,y,z=gps.locate(2)
        ui.message("GPS",x and ("Position: "..x..", "..y..", "..z) or "No GPS response.")
      end
    end
  end
end
