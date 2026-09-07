local ui=dofile('/sys/ui.lua')
local function install(url)
 if not http then ui.message('Package Center','HTTP API is disabled.') return end
 local ok,err=pcall(function() shell.run('wget','run',url) end)
 if not ok then ui.message('Package Center','Install failed:\n'..tostring(err)) end
end
local pkgs={
 {'Basalt 2 UI','https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua'},
 {'Pixelbox Lite','https://raw.githubusercontent.com/9551-Dev/pixelbox_lite/master/pixelbox_lite.lua'},
 {'Artist item system','https://raw.githubusercontent.com/SquidDev-CC/artist/master/bin/artist'},
 {'CraftOS mbs shell','https://raw.githubusercontent.com/SquidDev-CC/mbs/master/mbs.lua'},
 {'CC networking tools','https://github.com/SquidDev-CC/telem'},
}
local builtin={'Terminal','File Manager','Network Center','Device Center','System Monitor','Calculator','Clock','Process Manager','Turtle Control','Settings'}
while true do
 ui.clear(colors.black); ui.header('Suslix Package Center')
 local i=1
 term.setTextColor(colors.lime); term.setCursorPos(2,i+1); term.write('Built-in applications'); i=i+1
 for _,name in ipairs(builtin) do term.setCursorPos(4,i+1); term.setTextColor(colors.white); term.write('- '..name); i=i+1 end
 term.setTextColor(colors.lightBlue); term.setCursorPos(2,i+2); term.write('Open-source catalog')
 local base=i+3
 for n,p in ipairs(pkgs) do term.setCursorPos(4,base+n-1); term.setTextColor(colors.white); term.write(string.format('%d. %s',n,p[1])) end
 ui.footer('1-5 install   Q back')
 local e,k=os.pullEvent('key')
 if k==keys.q then return end
 if k>=keys.one and k<=keys.five then local n=k-keys.zero; if pkgs[n] then install(pkgs[n][2]) end end
end
