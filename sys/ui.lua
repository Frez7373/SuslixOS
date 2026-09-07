local ui = {}

function ui.clear(bg)
  term.setBackgroundColor(bg or colors.black)
  term.clear()
  term.setCursorPos(1,1)
end

function ui.header(title, bg, fg)
  local w = select(1, term.getSize())
  term.setBackgroundColor(bg or colors.blue)
  term.setTextColor(fg or colors.white)
  term.setCursorPos(1,1)
  term.write(string.rep(" ", w))
  term.setCursorPos(2,1)
  term.write(title)
end

function ui.footer(text, bg, fg)
  local w,h = term.getSize()
  term.setBackgroundColor(bg or colors.gray)
  term.setTextColor(fg or colors.white)
  term.setCursorPos(1,h)
  term.write(string.rep(" ", w))
  term.setCursorPos(2,h)
  term.write(text)
end

function ui.window(x,y,w,h,title)
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.black)
  for yy=y,y+h-1 do
    term.setCursorPos(x,yy)
    term.write(string.rep(" ",w))
  end
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.setCursorPos(x,y)
  term.write(string.rep(" ",w))
  term.setCursorPos(x+2,y)
  term.write(title or "Window")
end

function ui.button(x,y,w,label,active)
  term.setBackgroundColor(active and colors.blue or colors.gray)
  term.setTextColor(colors.white)
  term.setCursorPos(x,y)
  term.write(string.rep(" ",w))
  term.setCursorPos(x+math.max(0,math.floor((w-#label)/2)),y)
  term.write(label)
end

function ui.message(title,text)
  local w,h = term.getSize()
  local lines = {}
  for line in tostring(text):gmatch("[^\n]+") do table.insert(lines,line) end
  local bw = math.min(w-4, math.max(24, #title+8))
  for _,line in ipairs(lines) do bw = math.min(w-4, math.max(bw,#line+4)) end
  local bh = math.min(h-2,#lines+5)
  local x = math.floor((w-bw)/2)+1
  local y = math.floor((h-bh)/2)+1
  ui.window(x,y,bw,bh,title)
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.black)
  for i,line in ipairs(lines) do
    term.setCursorPos(x+2,y+1+i)
    term.write(line:sub(1,bw-4))
  end
  ui.button(x+bw-10,y+bh-2,8,"OK",true)
  while true do
    local e,_,mx,my = os.pullEvent()
    if e=="mouse_click" and mx>=x+bw-10 and mx<x+bw-2 and my==y+bh-2 then return end
    if e=="key" and _==keys.enter then return end
  end
end

return ui
