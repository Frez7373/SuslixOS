local ui=dofile('/sys/ui.lua')
local pages={
 {'Welcome','SuslixOS is an Opus-inspired desktop environment for CC:Tweaked.\nUse START or the keyboard shortcuts to launch apps.'},
 {'Core','F2 Terminal\nF3 File Manager\nF4 Network\nF5 Package Center\nF6 Devices'},
 {'Tips','HTTP is needed for the installer and open-source packages.\nOn turtles, Turtle Control gives safe manual actions.\nUse Process Manager when multishell is available.'},
 {'Credits','Inspired by the ideas behind OpusOS and other CC operating systems.\nOpen-source components are kept as optional packages where licenses and compatibility permit.'}
}
local page=1
while true do
 ui.clear(colors.black); ui.header('SuslixOS Help — '..pages[page][1])
 local lines=ui.wrap(pages[page][2],term.getSize()-4)
 for i,l in ipairs(lines) do term.setCursorPos(2,i+2); term.setTextColor(colors.white); term.write(l) end
 ui.footer('LEFT/RIGHT page   Q back')
 local e,k=os.pullEvent('key'); if k==keys.q then return elseif k==keys.left then page=page>1 and page-1 or #pages elseif k==keys.right then page=page<#pages and page+1 or 1 end
end
