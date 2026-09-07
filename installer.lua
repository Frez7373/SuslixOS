local BASE='https://raw.githubusercontent.com/Frez7373/SuslixOS/main/'
local VERSION='1.3.0'
local files={
 {'startup.lua','/startup.lua'},{'sys/boot.lua','/sys/boot.lua'},{'sys/ui.lua','/sys/ui.lua'},{'sys/recovery.lua','/sys/recovery.lua'},
 {'lib/suslix.lua','/lib/suslix.lua'},{'lib/config.lua','/lib/config.lua'},
 {'apps/desktop.lua','/apps/desktop.lua'},{'apps/bookmarks.lua','/apps/bookmarks.lua'},{'apps/myapps.lua','/apps/myapps.lua'},
 {'apps/terminal.lua','/apps/terminal.lua'},{'apps/fileman.lua','/apps/fileman.lua'},{'apps/packages.lua','/apps/packages.lua'},
 {'apps/settings.lua','/apps/settings.lua'},{'apps/network.lua','/apps/network.lua'},{'apps/monitor.lua','/apps/monitor.lua'},
 {'apps/devices2.lua','/apps/devices2.lua'},{'apps/netwatch.lua','/apps/netwatch.lua'},{'apps/rednet.lua','/apps/rednet.lua'},
 {'apps/sysinfo.lua','/apps/sysinfo.lua'},{'apps/calc.lua','/apps/calc.lua'},{'apps/clock.lua','/apps/clock.lua'},
 {'apps/procman.lua','/apps/procman.lua'},{'apps/turtle.lua','/apps/turtle.lua'},{'apps/help.lua','/apps/help.lua'},
 {'README.md','/SuslixOS-README.md'}
}
local function say(s,c) term.setTextColor(c or colors.white); print(s) end
term.setBackgroundColor(colors.black); term.clear(); term.setCursorPos(1,1)
say('SUSLIXOS INSTALLER',colors.lime); say('Simple desktop OS for CC:Tweaked',colors.lightGray); say('Version '..VERSION,colors.cyan); print()
if not http then error('HTTP API is disabled. Enable HTTP in CC:Tweaked settings.') end
say('This installer replaces /startup.lua.',colors.yellow); say('Old startup is backed up to /suslix/backup/startup.lua.',colors.yellow); print()
write('Continue? [y/N]: '); if read():lower()~='y' then return end
if not fs.exists('/suslix') then fs.makeDir('/suslix') end
if not fs.exists('/suslix/backup') then fs.makeDir('/suslix/backup') end
if fs.exists('/startup.lua') then
 local f=fs.open('/startup.lua','rb'); local d=f.readAll(); f.close(); local b=fs.open('/suslix/backup/startup.lua','wb'); b.write(d); b.close()
end
local function download(src,dst)
 local h,err=http.get(BASE..src,nil,true); if not h then return false,tostring(err) end
 local d=h.readAll(); h.close(); local dir=fs.getDir(dst); if dir~='' and not fs.exists(dir) then fs.makeDir(dir) end
 local f=fs.open(dst,'wb'); if not f then return false,'cannot write '..dst end; f.write(d); f.close(); return true
end
for i,p in ipairs(files) do
 write(string.format('[%02d/%02d] %-24s ',i,#files,p[1])); local ok,err=download(p[1],p[2])
 if ok then say('OK',colors.lime) else say('FAILED: '..err,colors.red); error('Installation aborted at '..p[1]) end
end
local v=fs.open('/suslix/version','w'); v.write(VERSION); v.close()
local m=fs.open('/suslix/install.info','w'); m.write('SuslixOS '..VERSION..'\nInstalled: '..os.date()); m.close()
say('\nSuslixOS '..VERSION..' installed successfully.',colors.lime); say('Settings are persistent. My Apps is ready.',colors.lightGray); sleep(1); os.reboot()
