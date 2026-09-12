local ui=dofile("/tempOS/ui/ui.lua")
local function run()
  local path=ui.input("Text Editor","File path:",""); if not path or path=="" then return end
  local lines={""}; if fs.exists(path) and not fs.isDir(path) then local f=fs.open(path,"r"); local s=f.readAll(); f.close(); lines={}; for l in (s.."\n"):gmatch("(.-)\n") do table.insert(lines,l) end; if #lines==0 then lines={""} end end
  local row,col=1,1; local scroll=1
  local function save() local f=fs.open(path,"w"); if not f then return false end; f.write(table.concat(lines,"\n")); f.close(); return true end
  while true do
    ui.clear(); ui.header("Editor - "..path); local w,h=term.getSize(); local usable=math.max(1,h-6); if row<scroll then scroll=row elseif row>=scroll+usable then scroll=row-usable+1 end
    for i=1,usable do local n=scroll+i-1; if n<=#lines then term.setCursorPos(1,i+2); write(string.format("%3d ",n)); term.setCursorPos(6,i+2); write(lines[n]:sub(1,w-5)) end end
    ui.button(2,h-2,12,"SAVE",false); ui.button(16,h-2,12,"QUIT",true); ui.footer("F5 save | F6 quit | arrows move")
    local e,a,b=os.pullEvent()
    if e=="char" then lines[row]=lines[row]:sub(1,col-1)..a..lines[row]:sub(col); col=col+1
    elseif e=="key" then
      if a==keys.enter then local left=lines[row]:sub(1,col-1); local right=lines[row]:sub(col); lines[row]=left; table.insert(lines,row+1,right); row=row+1; col=1
      elseif a==keys.backspace then if col>1 then lines[row]=lines[row]:sub(1,col-2)..lines[row]:sub(col); col=col-1 elseif row>1 then col=#lines[row-1]+1; lines[row-1]=lines[row-1]..lines[row]; table.remove(lines,row); row=row-1 end
      elseif a==keys.left then col=math.max(1,col-1) elseif a==keys.right then col=math.min(#lines[row]+1,col+1) elseif a==keys.up then row=math.max(1,row-1); col=math.min(col,#lines[row]+1) elseif a==keys.down then row=math.min(#lines,row+1); col=math.min(col,#lines[row]+1)
      elseif a==keys.f5 then save(); ui.message("Editor","Saved "..path) elseif a==keys.f6 then return end
    elseif e=="monitor_touch" or e=="mouse_click" then local x,y=b,os.pullEvent and (select(3, e,a,b) or b) or b; y=select(3,os.pullEvent()) end
    if e=="monitor_touch" or e=="mouse_click" then local x,y=b,select(3,os.pullEvent()) end
  end
end
run()
