local ui=dofile('/sys/ui.lua')
while true do
  ui.clear(colors.black); ui.header('System Information')
  local w,h=term.getSize(); local rows={
    'SuslixOS 1.0.0-alpha',
    'Computer ID: '..os.getComputerID(),
    'Label: '..(os.getComputerLabel() or '(none)'),
    'CraftOS: '..tostring(_HOST),
    'Lua: '.._VERSION,
    'Terminal: '..w..'x'..h,
    'Free: '..tostring(fs.getFreeSpace('/')),
    'Capacity: '..tostring(fs.getCapacity('/')),
    'Fuel: '..(turtle and tostring(turtle.getFuelLevel()) or 'N/A'),
    'Redstone sides: '..tostring(rs and 6 or 0),
  }
  for i,v in ipairs(rows) do term.setCursorPos(2,i+2); term.setTextColor(colors.white); term.write(v) end
  ui.footer('Q back   R refresh'); local e,k=os.pullEvent('key'); if k==keys.q then return end
end
