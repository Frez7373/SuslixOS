local ui=dofile('/sys/ui.lua')
local function download(url,path)
 if not http then ui.message('Package Center','HTTP API is disabled.') return end
 local h,err=http.get(url,nil,true); if not h then ui.message('Package Center','Download failed:\n'..tostring(err)); return end
 local data=h.readAll(); h.close(); local dir=fs.getDir(path); if dir~='' and not fs.exists(dir) then fs.makeDir(dir) end
 local f=fs.open(path,'wb'); if not f then ui.message('Package Center','Cannot write '..path); return end; f.write(data); f.close(); ui.message('Package Center','Installed to '..path)
end
local pkgs={
 {'Basalt 2 UI','https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua','run'},
 {'Pixelbox Lite','https://raw.githubusercontent.com/9551-Dev/pixelbox_lite/master/pixelbox_lite.lua','file:/lib/pixelbox_lite.lua'},
 {'Artist','https://raw.githubusercontent.com/SquidDev-CC/artist/master/bin/artist','file:/bin/artist'},
 {'MBS shell','https://raw.githubusercontent.com/SquidDev-CC/mbs/master/mbs.lua','file:/bin/mbs'},
 {'Telem','https://raw.githubusercontent.com/cyberbit/telem/main/telem.lua','file:/lib/telem.lua'},
}
local builtin={'Terminal','File Manager','Network Center','Rednet Center','Device Center','System Monitor','System Info','Calculator','Clock','Process Manager','Turtle Control','Settings'}
while true do
 ui.clear(colors.black); ui.header('Suslix Package Center'); local row=3
 term.setTextColor(colors.lime); term.setCursorPos(2,row); term.write('Built-in applications'); row=row+1
 for _,name in ipairs(builtin) do term.setCursorPos(4,row); term.setTextColor(colors.white); term.write('- '..name); row=row+1 end
 row=row+1; term.setTextColor(colors.lightBlue); term.setCursorPos(2,row); term.write('Open-source catalog'); row=row+2
 for n,p in ipairs(pkgs) do term.setCursorPos(4,row+n-1); term.setTextColor(colors.white); term.write(string.format('%d. %s',n,p[1])) end
 ui.footer('1-5 install   Q back'); local e,k=os.pullEvent('key')
 if k==keys.q then return end
 if k>=keys.one and k<=keys.five then local n=k-keys.zero; local p=pkgs[n]; if p then
   if p[3]=='run' then local ok,err=pcall(function() shell.run('wget','run',p[2]) end); if not ok then ui.message('Package Center',tostring(err)) end
   else local spec=p[3]; local path=spec:sub(6); download(p[2],path) end
 end end
end
