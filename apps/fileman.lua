local ui = dofile("/sys/ui.lua")
local path = "/"

local function draw()
  ui.clear(colors.black)
  ui.header("File Manager   " .. path)
  local w,h = term.getSize()
  local list = fs.list(path)
  table.sort(list)
  local max = h-3
  for i=1,math.min(#list,max) do
    local name=list[i]
    local full=fs.combine(path,name)
    local isDir=fs.isDir(full)
    term.setBackgroundColor(colors.black)
    term.setTextColor(isDir and colors.lightBlue or colors.white)
    term.setCursorPos(2,i+2)
    term.write((isDir and "[DIR] " or "      ") .. name)
  end
  ui.footer("ENTER/open   B/back   Q/quit   DEL/delete")
  return list
end

while true do
  local list=draw()
  local e,k=table.unpack({os.pullEvent()})
  if e=="key" then
    if k==keys.q then return end
    if k==keys.b then
      if path~="/" then path=fs.getDir(path); if path=="" then path="/" end end
    elseif k==keys.backspace then
      if path~="/" then path=fs.getDir(path); if path=="" then path="/" end end
    elseif k==keys.enter then
      term.setCursorPos(2,term.getSize())
      write("Open number: ")
      local n=tonumber(read())
      if n and list[n] and fs.isDir(fs.combine(path,list[n])) then
        path=fs.combine(path,list[n])
        if path=="" then path="/" end
      end
    elseif k==keys.delete then
      term.setCursorPos(2,term.getSize())
      write("Delete number: ")
      local n=tonumber(read())
      if n and list[n] then fs.delete(fs.combine(path,list[n])) end
    end
  elseif e=="mouse_click" then
    local _,_,x,y=os.pullEvent("mouse_click")
  end
end
