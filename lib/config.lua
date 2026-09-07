local M = {}
local ROOT = "/suslix"
local SETTINGS = ROOT .. "/settings.cfg"

M.defaults = {
  theme = "blue",
  accent = "cyan",
  clock24 = "true",
  wallpaper = "grid",
  showClock = "true",
  animations = "true",
}

local function ensure()
  if not fs.exists(ROOT) then fs.makeDir(ROOT) end
end

function M.load()
  ensure()
  local t = {}
  for k,v in pairs(M.defaults) do t[k] = v end
  if fs.exists(SETTINGS) then
    local f = fs.open(SETTINGS, "r")
    if f then
      for line in f.readAll():gmatch("[^\\n]+") do
        local k,v = line:match("^([^=]+)=(.*)$")
        if k and t[k] ~= nil then t[k] = v end
      end
      f.close()
    end
  end
  return t
end

function M.save(t)
  ensure()
  local f = fs.open(SETTINGS, "w")
  if not f then return false end
  for k,v in pairs(t) do f.writeLine(tostring(k) .. "=" .. tostring(v)) end
  f.close()
  return true
end

function M.colors(theme)
  if theme == "green" then
    return { bg=colors.black, surface=colors.green, panel=colors.gray, text=colors.white, muted=colors.lightGray, accent=colors.lime, selected=colors.green }
  elseif theme == "purple" then
    return { bg=colors.black, surface=colors.purple, panel=colors.gray, text=colors.white, muted=colors.lightGray, accent=colors.pink, selected=colors.purple }
  elseif theme == "dark" then
    return { bg=colors.black, surface=colors.gray, panel=colors.gray, text=colors.white, muted=colors.lightGray, accent=colors.lightBlue, selected=colors.lightGray }
  else
    return { bg=colors.black, surface=colors.blue, panel=colors.gray, text=colors.white, muted=colors.lightGray, accent=colors.cyan, selected=colors.blue }
  end
end

return M
