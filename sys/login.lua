local ui=dofile('/sys/ui.lua')
local crypto=dofile('/lib/crypto.lua')
local users=dofile('/lib/users.lua')
while true do
  local list=users.list()
  term.setBackgroundColor(colors.black); term.clear(); term.setCursorPos(1,1)
  ui.header('Welcome to SuslixOS',colors.blue,colors.white)
  term.setCursorPos(3,3); term.setTextColor(colors.lightGray); term.write('Choose a user')
  if #list==0 then users.add('Owner','suslix'); list=users.list() end
  for i,u in ipairs(list) do
    term.setCursorPos(4,4+i); term.setTextColor(colors.white); term.write(string.format('%d  %s',i,u.name))
  end
  term.setCursorPos(3,6+#list); term.setTextColor(colors.cyan); term.write('N  New user')
  term.setCursorPos(3,7+#list); term.setTextColor(colors.lightGray); term.write('R  Restart   Q  Shutdown')
  local e,k=os.pullEvent('key')
  if k==keys.n then
    term.setCursorPos(3,9+#list); term.setTextColor(colors.white); write('Name: '); local name=read()
    term.setCursorPos(3,10+#list); write('Password (empty = none): '); local pw=read('*')
    if name~='' then users.add(name,pw) end
  elseif k>=keys.one and k<=keys.nine then
    local idx=k-keys.zero; local u=list[idx]
    if u then
      term.setCursorPos(3,9+#list); write('Password: '); local pw=read('*')
      if users.check(u.id,pw) then users.setCurrent(u.id); return true else ui.message('Sign in failed','Wrong password.') end
    end
  elseif k==keys.r then os.reboot() elseif k==keys.q then os.shutdown() end
end
