local ui=dofile('/sys/ui.lua')
while true do
  ui.clear(colors.black); ui.header('Clock & Date')
  local w,h=term.getSize(); local t=os.epoch('utc')
  local s=os.date('%Y-%m-%d %H:%M:%S',t/1000)
  term.setTextColor(colors.white)
  ui.center(s,math.floor(h/2)-1,colors.white)
  ui.center('Computer time / Minecraft world clock',math.floor(h/2)+1,colors.lightGray)
  ui.footer('Q back   R refresh')
  local e,k=os.pullEvent('key'); if k==keys.q then return end
end
