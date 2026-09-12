local ui=dofile("/tempOS/ui/ui.lua")
local function run()
  local path=ui.input("Text Editor","File path:",""); if not path or path=="" then return end
  local lines={""}; if fs.exists(path) and not fs.isDir(path) then local f=fs.open(path,"r"); local s=f.readAll(); f.close(); lines={}; for l in (s.."\n"):gmatch("(.-)\n") do table.insert(lines,l) end; if #lines==0 then lines={""} end end
  local row,col=1,1; local scroll=1
  local function save() local f=fs.open(path,"w"); if f then f.write(table.concat(lines,"\n")); f.close(); return true end return false end
  while true do
    ui.clear(); ui.header("Editor - "..path); local w,h=term.getSize(); local usable=h-4; scroll=math.max(1,math.min(scroll,row))
    for i=1,usable do local n=scroll+i-1; if n<=#lines then term.setCursorPos(1,i+2); write(string.format("%3d ",n)); term.setCursorPos(6,i+2); write(lines[n]:sub(1,w-5)) end end
    term.setCursorPos(6+(col-1),2+(row-scroll)); term.setTextColor(colors.black); term.setBackgroundColor(colors.white); write((lines[row]:sub(col,col)~="" and lines[row]:sub(col,col) or " ")); term.setBackgroundColor(colors.black); term.setTextColor(colors.white); ui.footer("Ctrl+S save | Ctrl+Q quit")
    local e,a,b=os.pullEvent()
    if e=="char" then lines[row]=lines[row]:sub(1,col-1)..a..lines[row]:sub(col); col=col+1
    elseif e=="key" then
      if a==keys.enter then local left=lines[row]:sub(1,col-1); local right=lines[row]:sub(col); lines[row]=left; table.insert(lines,row+1,right); row=row+1; col=1
      elseif a==keys.backspace then if col>1 then lines[row]=lines[row]:sub(1,col-2)..lines[row]:sub(col); col=col-1 elseif row>1 then col=#lines[row-1]+1; lines[row-1]=lines[row-1]..lines[row]; table.remove(lines,row); row=row-1 end
      elseif a==keys.left then col=math.max(1,col-1) elseif a==keys.right then col=math.min(#lines[row]+1,col+1) elseif a==keys.up then row=math.max(1,row-1); col=math.min(col,#lines[row]+1) elseif a==keys.down then row=math.min(#lines,row+1); col=math.min(col,#lines[row]+1)
      elseif a==keys.s and (b==keys.leftCtrl or b==keys.rightCtrl) then save()
      elseif a==keys.q and (b==keys.leftCtrl or b==keys.rightCtrl) then return end
    elseif e=="monitor_touch" or e=="mouse_click" then if b>=1 and b<=10 and a==1 then save(); ui.message("Editor","Saved "..path) end end
  end
end
run()
