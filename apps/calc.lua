local ui=dofile('/sys/ui.lua')
local expr=''
while true do
  ui.clear(colors.black); ui.header('Calculator')
  term.setTextColor(colors.white); term.setCursorPos(2,4); term.write('Expression: '..expr)
  term.setCursorPos(2,6); term.write('Enter expression (Lua math), or Q to exit.')
  ui.footer('ENTER evaluate   BACKSPACE edit   Q back')
  local e,k=os.pullEvent()
  if e=='key' and k==keys.q then return
  elseif e=='key' and k==keys.enter then
    if expr~='' then
      local fn=load('return '..expr, 'calc', 't', setmetatable({math=math},{__index=_ENV}))
      local ok,res=pcall(fn)
      ui.message('Calculator', ok and tostring(res) or ('Error: '..tostring(res)))
    end
  elseif e=='char' then expr=expr..k
  elseif e=='key' and k==keys.backspace then expr=expr:sub(1,-2)
  end
end
