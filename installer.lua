local BASE='https://raw.githubusercontent.com/Frez7373/SuslixOS/main/'
local VERSION='1.1.0'
local files={
 {'startup.lua','/startup.lua'},{'sys/boot.lua','/sys/boot.lua'},{'sys/ui.lua','/sys/ui.lua'},{'sys/recovery.lua','/sys/recovery.lua'},{'lib/suslix.lua','/lib/suslix.lua'},
 {'apps/desktop.lua','/apps/desktop.lua'},{'apps/terminal.lua','/apps/terminal.lua'},{'apps/fileman.lua','/apps/fileman.lua'},{'apps/packages.lua','/apps/packages.lua'},{'apps/settings.lua','/apps/settings.lua'},{'apps/network.lua','/apps/network.lua'},{'apps/monitor.lua','/apps/monitor.lua'},
 {'apps/devices2.lua','/apps/devices2.lua'},{'apps/netwatch.lua','/apps/netwatch.lua'},{'apps/rednet.lua','/apps/rednet.lua'},{'apps/sysinfo.lua','/apps/sysinfo.lua'},{'apps/calc.lua','/apps/calc.lua'},{'apps/clock.lua','/apps/clock.lua'},{'apps/procman.lua','/apps/procman.lua'},{'apps/turtle.lua','/apps/turtle.lua'},
 {'README.md','/SuslixOS-README.md'}
}
local function say(s,c) term.setTextColor(c or colors.white); print(s) end
term.setBackgroundColor(colors.black); term.clear(); term.setCursorPos(1,1)
say('SUSLIXOS INSTALLER',colors.lime); say('Modern desktop OS for CC:Tweaked',colors.lightGray); print()
if not http then error('HTTP API is disabled. Enable HTTP in CC:Tweaked settings.') end
say('This installer replaces /startup.lua.',colors.yellow); say('A backup will be created at /suslix/backup/startup.lua',colors.yellow); print()
write('Continue? [y/N]: '); if read():lower()~='y' then return end
if fs.exists('/startup.lua') then
 fs.makeDir('/suslix/backup')
 local f=fs.open('/startup.lua','rb'); local data=f.readAll(); f.close()
 local b=fs.open('/suslix/backup/startup.lua','wb'); b.write(data); b.close()
end
local function download(src,dst)
 local h,err=http.get(BASE..src,nil,true); if not h then return false,tostring(err) end
 local data=h.readAll(); h.close(); local dir=fs.getDir(dst); if dir~='' then fs.makeDir(dir) end
 local f=fs.open(dst,'wb'); if not f then return false,'cannot write '..dst end; f.write(data); f.close(); return true
end
for i,p in ipairs(files) do
 write(string.format('[%02d/%02d] %-26s ',i,#files,p[1])); local ok,err=download(p[1],p[2]); if ok then say('OK',colors.lime) else say('FAILED: '..err,colors.red); error('Installation aborted.') end
end
fs.makeDir('/suslix'); local f=fs.open('/suslix/version','w'); f.write(VERSION); f.close()
local meta=fs.open('/suslix/install.info','w'); meta.write('SuslixOS '..VERSION..'\nInstalled: '..os.date()); meta.close()
say('\nSuslixOS '..VERSION..' installed successfully.',colors.lime); say('Rebooting...',colors.white); sleep(1); os.reboot()
