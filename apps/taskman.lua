local ui=dofile('/sys/ui.lua')
local config=dofile('/lib/config.lua')
local function refresh()
 local s=config.load(); local c=config.colors(s.theme); ui.clear(c.bg); ui.header('Task Manager',c.surface,c.text)
 local w,h=term.getSize()
 if not multishell then ui.message('Task Manager','Multitasking is not available.'); return end
 local n=multishell.getCount(); local cur=multishell.getCurrent()
 term.setCursorPos(3,3); term.setTextColor(c.muted); term.write('Open windows: '..n)
 for i=1,n do
  local title=multishell.getTitle(i) or ('Window '..i); term.setCursorPos(3,4+i); term.setTextColor(i==cur and c.accent or c.text); term.write(string.format('%d  %s%s',i,title,i==cur and '  < active' or ''))
 end
 term.setCursorPos(3,h-2); term.setTextColor(c.muted); term.write('1-9 switch   X close selected   Q Home')
 local e,k=os.pullEvent('key')
 if k==keys.q then return elseif k>=keys.one and k<=keys.nine then local i=k-keys.zero; if i<=n then multishell.setFocus(i) end
 elseif k==keys.x and n>1 then multishell.setFocus(math.min(cur,n)); multishell.launch({},'/apps/close.lua') end
end
while true do refresh() end
