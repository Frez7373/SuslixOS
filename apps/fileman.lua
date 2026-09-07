local ui = dofile("/sys/ui.lua")
local path = "/"
local selected = 1

local function draw()
  ui.clear(colors.black)
  ui.header("File Manager   " .. path)
  local _,h = term.getSize()
  local list = fs.list(path)
  table.sort(list)
  local max = h-3
  if selected > #list then selected = math.max(1,#list) end
  for i=1,math.min(#list,max) do
    local name=list[i]
    local full=fs.combine(path,name)
    local isDir=fs.isDir(full)
    term.setBackgroundColor(i==selected and colors.blue or colors.black)
    term.setTextColor(i==selected and colors.white or (isDir and colors.lightBlue or colors.white))
    term.setCursorPos(2,i+2)
    term.write(string.rep(" ",math.max(1,select(1,term.getSize())-2)))
    term.setCursorPos(2,i+2)
    term.write((isDir and "[DIR] " or "      ") .. name)
  end
  ui.footer("UP/DOWN select  ENTER open  B back  DEL delete  Q quit")
  return list
end

while true do
  local list=draw()
  local e,a,_,my=os.pullEvent()
  if e=="key" then
    if a==keys.q then return
    elseif a==keys.up then selected=math.max(1,selected-1)
    elseif a==keys.down then selected=math.min(#list,selected+1)
    elseif a==keys.b or a==keys.backspace then
      if path~="/" then path=fs.getDir(path); if path=="" then path="/" end; selected=1 end
    elseif a==keys.enter and list[selected] then
      local full=fs.combine(path,list[selected])
      if fs.isDir(full) then path=full; selected=1
      else shell.run("edit",full) end
    elseif a==keys.delete and list[selected] then
      fs.delete(fs.combine(path,list[selected]))
      if selected>#list-1 then selected=math.max(1,#list-1) end
    end
  elseif e=="mouse_click" then
    if my>=3 and my<=h-1 then selected=my-2 end
  end
end
