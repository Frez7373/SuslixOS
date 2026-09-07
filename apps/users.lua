local ui=dofile('/sys/ui.lua')
local config=dofile('/lib/config.lua')
local users=dofile('/lib/users.lua')
local function draw()
 local s=config.load(); local c=config.colors(s.theme); ui.clear(c.bg); ui.header('Users',c.surface,c.text)
 local list=users.list(); local w,h=term.getSize(); term.setTextColor(c.muted); term.setCursorPos(3,3); term.write('Accounts on this computer')
 for i,u in ipairs(list) do term.setCursorPos(3,i+4); term.setTextColor(c.text); term.write(string.format('%d  %s%s',i,u.name,u.id==users.current() and '  (current)' or '')) end
 term.setCursorPos(3,h-3); term.setTextColor(c.accent); term.write('N New   S Switch   P Change password'); term.setTextColor(c.text)
 ui.footer('Choose a user • Home',c.panel,c.text)
end
while true do
 draw(); local e,k=os.pullEvent()
 if e=='key' then
  local list=users.list()
  if k==keys.q then return
  elseif k==keys.n then term.setCursorPos(3,term.getSize()-2); write('Name: '); local n=read(); term.setCursorPos(3,term.getSize()-1); write('Password: '); local p=read('*'); if n~='' then users.add(n,p) end
  elseif k==keys.s then term.setCursorPos(3,term.getSize()-2); write('User number: '); local i=tonumber(read()); if list[i] then users.setCurrent(list[i].id); os.reboot() end
  elseif k==keys.p then local id=users.current(); if id then term.setCursorPos(3,term.getSize()-2); write('Current password: '); local old=read('*'); if users.check(id,old) then term.setCursorPos(3,term.getSize()-1); write('New password: '); local np=read('*'); users.setPassword(id,np) end end end
 end
end
