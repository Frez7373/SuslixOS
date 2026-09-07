local ui=dofile('/sys/ui.lua')
local function describe(name)
 local t=peripheral.getType(name) or 'unknown'
 local methods=peripheral.getMethods(name) or {}
 return t,table.concat(methods,', ')
end
while true do
 ui.clear(colors.black); ui.header('Device Center')
 local list=peripheral.getNames()
 if #list==0 then term.setCursorPos(2,4); term.write('No peripherals detected.')
 else for i,n in ipairs(list) do
   local t=peripheral.getType(n) or '?'; term.setCursorPos(2,i+2); term.setTextColor(colors.white); term.write(string.format('%2d  %-18s %s',i,n,t))
  end end
 ui.footer('ENTER inspect   R refresh   Q back')
 local e,k=os.pullEvent(); if e=='key' then
  if k==keys.q then return elseif k==keys.enter and #list>0 then write('Device number: '); local n=tonumber(read()); if n and list[n] then local t,m=describe(list[n]); ui.message('Device',list[n]..'\nType: '..t..'\nMethods: '..m) end end
 end
end
