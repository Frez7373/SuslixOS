local ui=dofile('/sys/ui.lua')
local core=dofile('/lib/suslix.lua')
local function center(text,y,c) local w=term.getSize(); core.center(text,y,c) end
term.setBackgroundColor(colors.black); term.clear(); term.setCursorPos(1,1)
local w,h=term.getSize(); local titleY=math.max(2,math.floor(h/2)-4)
for frame=1,18 do
  term.setBackgroundColor(colors.black); term.clear()
  local dots=string.rep('.',(frame-1)%4)
  center('SUSLIXOS',titleY,colors.cyan)
  center('2.0.0',titleY+1,colors.lightBlue)
  center('Starting system'..dots,titleY+3,colors.white)
  local width=math.max(12,math.min(w-8,32)); local progress=math.floor(width*frame/18)
  term.setCursorPos(math.floor((w-width)/2)+1,titleY+5); term.setTextColor(colors.gray); term.write('['..string.rep(' ',width)..']')
  term.setCursorPos(math.floor((w-width)/2)+2,titleY+5); term.setTextColor(colors.cyan); term.write(string.rep('#',progress))
  local checks={'Kernel','Display','Storage','Devices','Security','Desktop'}
  term.setCursorPos(math.max(2,math.floor(w/2)-12),titleY+7); term.setTextColor(colors.lightGray); term.write(checks[math.min(#checks,math.floor((frame-1)/3)+1)]..' ready')
  sleep(0.11)
end
if fs.exists('/sys/login.lua') then shell.run('/sys/login.lua') end
shell.run('/apps/desktop.lua')
