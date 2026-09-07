local ui=dofile('/sys/ui.lua')
local function draw()
 ui.clear(colors.black); ui.header('Process Manager')
 if multishell then
  local n=multishell.getCount(); local current=multishell.getCurrent()
  for i=1,n do
   local title=multishell.getTitle(i) or ('tab '..i)
   term.setCursorPos(2,i+2); term.setTextColor(i==current and colors.lime or colors.white)
   term.write(string.format('%2d  %s',i,title))
  end
  ui.footer('1-9 switch   X new tab   Q back')
 else ui.message('Process Manager','multishell is not available in this runtime.') end
end
while true do
 draw(); local e,k=os.pullEvent()
 if e=='key' then
  if k==keys.q then return
  elseif multishell and k>=keys.one and k<=keys.nine then local n=k-keys.zero; if n<=multishell.getCount() then multishell.setFocus(n) end
  elseif multishell and k==keys.x then multishell.launch({},'/apps/terminal.lua') end
 end
end
