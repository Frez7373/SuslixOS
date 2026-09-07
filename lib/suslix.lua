local M = {}

function M.readFile(path)
  if not fs.exists(path) then return nil end
  local f = fs.open(path, "r")
  if not f then return nil end
  local s = f.readAll()
  f.close()
  return s
end

function M.writeFile(path, data)
  local dir = fs.getDir(path)
  if dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end
  local f = fs.open(path, "w")
  if not f then return false end
  f.write(data or "")
  f.close()
  return true
end

function M.center(text, y, color)
  local w = term.getSize()
  local x = math.max(1, math.floor((w - #text) / 2) + 1)
  term.setTextColor(color or colors.white)
  term.setCursorPos(x, y)
  term.write(text)
end

function M.button(x, y, w, label, bg, fg)
  term.setBackgroundColor(bg or colors.gray)
  term.setTextColor(fg or colors.white)
  term.setCursorPos(x, y)
  term.write(string.rep(" ", w))
  local tx = x + math.max(0, math.floor((w - #label) / 2))
  term.setCursorPos(tx, y)
  term.write(label)
end

function M.wrap(text, width)
  local out, line = {}, ""
  for word in tostring(text):gmatch("%S+") do
    if #line > 0 and #line + #word + 1 > width then
      table.insert(out, line)
      line = word
    else
      line = line == "" and word or line .. " " .. word
    end
  end
  if line ~= "" then table.insert(out, line) end
  return out
end

function M.safeCall(fn, ...)
  local ok, a, b = pcall(fn, ...)
  return ok, a, b
end

return M
