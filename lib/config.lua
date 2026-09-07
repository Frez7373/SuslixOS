local M = {}
local ROOT = "/suslix"
local SETTINGS = ROOT .. "/settings.cfg"

M.defaults = {
  theme = "blue",
  wallpaper = "plain",
  clock24 = "true",
  showClock = "true",
  animations = "true",
}

local function ensure()
  if not fs.exists(ROOT) then fs.makeDir(ROOT) end
end

local function clean(v)
  return tostring(v or ""):gsub("[\r\n]", "")
end

function M.load()
  ensure()
  local t = {}
  for k,v in pairs(M.defaults) do t[k] = v end
  if fs.exists(SETTINGS) then
    local f = fs.open(SETTINGS, "r")
    if f then
      local data = f.readAll() or ""
      f.close()
      for line in data:gmatch("[^\n]+") do
        line = line:gsub("\r", "")
        local k,v = line:match("^([^=]+)=(.*)$")
        if k and t[k] ~= nil then t[k] = v end
      end
    end
  end
  return t
end

function M.save(t)
  ensure()
  local f = fs.open(SETTINGS, "w")
  if not f then return false, "cannot write " .. SETTINGS end
  for k,_ in pairs(M.defaults) do
    if t[k] ~= nil then
      f.writeLine(k .. "=" .. clean(t[k]))
    end
  end
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
