local ui=dofile("/tempOS/ui/ui.lua")
local p=ui.input("Text Editor","File path:","")
if p and p~="" then
 local text=""
 if fs.exists(p) and not fs.isDir(p) then local f=fs.open(p,"r"); if f then text=f.readAll(); f.close() end end
 while true do
  ui.clear(); ui.header("Text Editor"); term.setCursorPos(2,3); print("File: "..p); print(""); print(text:sub(1,math.max(1,term.getSize()-7))); ui.button(2,term.getSize()-2,12,"SAVE",false); ui.button(16,term.getSize()-2,12,"QUIT",true); ui.footer("Type with keyboard; F5 saves; F6 quits")
  local e,a,b,c=os.pullEvent()
  if e=="char" then text=text..a
  elseif e=="key" and a==keys.f5 then local f=fs.open(p,"w"); if f then f.write(text); f.close(); ui.message("Text Editor","Saved.") end
  elseif e=="key" and a==keys.f6 then return
  elseif e=="monitor_touch" or e=="mouse_click" then local x,y=b,c; local h=term.getSize(); if ui.hit(2,h-2,12,1,x,y) then local f=fs.open(p,"w"); if f then f.write(text); f.close(); ui.message("Text Editor","Saved.") end elseif ui.hit(16,h-2,12,1,x,y) then return end end
 end
end
