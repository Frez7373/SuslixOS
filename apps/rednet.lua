local ui=dofile('/sys/ui.lua')
local function pickModem()
 if not rednet then return nil end
 for _,n in ipairs(peripheral.getNames()) do if peripheral.getType(n)=='modem' then return n end end
end
local modem=pickModem()
if modem and not rednet.isOpen(modem) then rednet.open(modem) end
while true do
 ui.clear(colors.black); ui.header('Rednet Center')
 term.setCursorPos(2,4); term.setTextColor(colors.white); term.write('Modem: '..(modem or 'not found'))
 term.setCursorPos(2,6); term.write('1  Discover computers')
 term.setCursorPos(2,7); term.write('2  Broadcast ping')
 term.setCursorPos(2,8); term.write('Q  Back')
 local e,k=os.pullEvent('key')
 if k==keys.q then return
 elseif k==keys.one and modem then rednet.host('suslix','suslix-'..os.getComputerID()); local list=rednet.lookup('suslix'); ui.message('Discovery',list and ('Found: '..tostring(list)) or 'No host answered.')
 elseif k==keys.two and modem then rednet.broadcast({type='suslix_ping',id=os.getComputerID()},'suslix'); ui.message('Broadcast','Ping sent on protocol suslix.') end
end
