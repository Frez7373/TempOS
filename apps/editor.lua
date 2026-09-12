local T=dofile("/ui/theme.lua")
local path=TempOS.editorPath
TempOS.editorPath=nil
if not path or path=="" then term.clear(); T.text(2,2,"Text Editor",T.accent2); T.text(2,4,"File path:",T.fg); term.setCursorPos(2,5); path=read() end
if not path or path=="" then return end
if not fs.exists(path) then local f=fs.open(path,"w"); if f then f.close() end end
local f=fs.open(path,"r"); local text=f and f.readAll() or ""; if f then f.close() end
local lines={}; for line in (text.."\n"):gmatch("(.-)\n") do table.insert(lines,line) end; if #lines==0 then lines={""} end
local cursor=1
local function redraw()
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,1,"Editor",T.accent2); T.text(10,1,path,T.muted)
  for i=1,math.min(#lines,h-3) do T.text(2,i+2,string.format("%3d ",i)..lines[i]:sub(1,w-7),T.fg) end
  T.text(2,h,"[S] Save  [Q/ESC] Exit  [N] New line",T.muted)
end
local function save() local out=fs.open(path,"w"); if out then out.write(table.concat(lines,"\n")); out.close(); T.text(2,math.max(1,term.getSize()-1),"Saved",T.success); sleep(.4); end end
redraw()
while true do
  local e,a=os.pullEvent()
  if e=="key" then
    if a==keys.esc or a==keys.q then break
    elseif a==keys.s then save(); redraw()
    elseif a==keys.n or a==keys.enter then table.insert(lines,cursor+1,""); cursor=math.min(cursor+1,#lines); redraw()
    elseif a==keys.up then cursor=math.max(1,cursor-1); redraw()
    elseif a==keys.down then cursor=math.min(#lines,cursor+1); redraw()
    elseif a==keys.backspace then lines[cursor]=lines[cursor]:sub(1,-2); redraw() end
  elseif e=="char" then lines[cursor]=lines[cursor]..a; redraw() end
end
