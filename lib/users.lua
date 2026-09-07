local M={}
local ROOT='/suslix/users'; local CURRENT='/suslix/current_user'
local function dir() if not fs.exists('/suslix') then fs.makeDir('/suslix') end; if not fs.exists(ROOT) then fs.makeDir(ROOT) end end
local function readFile(p) local f=fs.open(p,'r'); if not f then return nil end; local d=f.readAll() or ''; f.close(); return d end
local function writeFile(p,d) local f=fs.open(p,'w'); if not f then return false end; f.write(d); f.close(); return true end
local function hash(s) local h=0x811c9dc5 for i=1,#s do h=((h ~ s:byte(i))*16777619)%4294967296 end return string.format('%08x',h) end
local function path(id) return ROOT..'/'..id..'.cfg' end
local function sanitize(s) return tostring(s or ''):gsub('[^%w_%-]',''):sub(1,24) end
function M.list() dir(); local out={}; for _,n in ipairs(fs.list(ROOT)) do local id=n:match('^(.-)%.cfg$'); if id then local d=readFile(path(id)) or ''; local name=d:match('name=(.-)\n') or id; local hp=d:match('hash=(.-)\n') or ''; table.insert(out,{id=id,name=name,hash=hp}) end end; table.sort(out,function(a,b)return a.name:lower()<b.name:lower() end); return out end
function M.add(name,password) dir(); local id=sanitize(name)..'_'..tostring(os.epoch('utc')); local d='name='..tostring(name):gsub('[\r\n=]',' ')..'\n'..'hash='..hash(password or '')..'\n'; return writeFile(path(id),d),id end
function M.check(id,password) local d=readFile(path(id)); if not d then return false end; return (d:match('hash=(.-)\n') or '')==hash(password or '') end
function M.setCurrent(id) dir(); writeFile(CURRENT,id); end
function M.current() return readFile(CURRENT) end
function M.currentName() local id=M.current(); if not id then return 'Guest' end; for _,u in ipairs(M.list()) do if u.id==id then return u.name end end; return 'Guest' end
return M
