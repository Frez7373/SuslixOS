local ui=dofile('/sys/ui.lua')
if not turtle then ui.message('Turtle Control','This application must run on a turtle.'); return end
local actions={
 {'Forward',turtle.forward},{'Back',turtle.back},{'Up',turtle.up},{'Down',turtle.down},
 {'Turn left',turtle.turnLeft},{'Turn right',turtle.turnRight},{'Dig forward',turtle.dig},
 {'Place forward',turtle.place},{'Refuel',function() return turtle.refuel(1) end}
}
while true do
 ui.clear(colors.black); ui.header('Turtle Control')
 for i,a in ipairs(actions) do term.setCursorPos(2,i+2); term.setTextColor(colors.white); term.write(string.format('%2d  %s',i,a[1])) end
 term.setCursorPos(2,#actions+4); term.write('Fuel: '..tostring(turtle.getFuelLevel()))
 ui.footer('1-9 action   Q back')
 local e,k=os.pullEvent('key'); if k==keys.q then return end
 local n=k-keys.zero; if actions[n] then local ok,err=pcall(actions[n][2]); if not ok then ui.message('Turtle',tostring(err)) end end
end
