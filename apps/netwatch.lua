local ui=dofile('/sys/ui.lua')
while true do
 ui.clear(colors.black); ui.header('Network Watch')
 local names=peripheral.getNames()
 local row=2
 for _,name in ipairs(names) do
  if peripheral.getType(name)=='modem' then
   local m=peripheral.wrap(name); local open=m.getOpenPorts and m.getOpenPorts() or {}
   term.setCursorPos(2,row); term.setTextColor(colors.lime); term.write(name..'  modem')
   row=row+1
   term.setTextColor(colors.white); term.setCursorPos(4,row); term.write('Open ports: '..table.concat(open,', ')); row=row+1
  end
 end
 if row==2 then term.setCursorPos(2,4); term.setTextColor(colors.yellow); term.write('No modem detected.') end
 ui.footer('R refresh   Q back')
 local e,k=os.pullEvent('key'); if k==keys.q then return end
end
