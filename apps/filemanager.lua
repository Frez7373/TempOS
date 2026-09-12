local T=dofile("/ui/theme.lua")
local cwd="/"
local function list() local all=fs.list(cwd); table.sort(all); return all end
local function draw(items)
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"Files",T.accent2); T.text(2,3,cwd,T.muted); T.text(math.max(1,w-6),2,"[ESC]",T.muted)
  for i,n in ipairs(items) do if i>h-5 then break end local mark=fs.isDir(fs.combine(cwd,n)) and "/" or " "; T.text(3,i+4,mark.." "..n,T.fg) end
  T.text(2,h-2,"Touch/click item. Enter=path  Backspace=parent",T.muted)
end
while true do
  local items=list(); draw(items); local e,a,b,c=os.pullEvent(); local x,y
  if e=="monitor_touch" and a==TempOS.screenSide then x,y=b,c elseif e=="mouse_click" then x,y=b,c end
  if e=="key" and a==keys.esc then break end
  if e=="key" and a==keys.enter then term.setCursorPos(2,term.getSize()-1); write("Path: "); local p=read(); if p and fs.exists(p) then cwd=fs.isDir(p) and fs.combine(p) or fs.getDir(p); if cwd=="" then cwd="/" end end
  elseif e=="key" and a==keys.backspace then cwd=fs.getDir(cwd); if cwd=="" then cwd="/" end
  elseif x and y and y>=5 and y<5+#items then local n=items[y-4]; local p=fs.combine(cwd,n); if fs.isDir(p) then cwd=p else TempOS.editorPath=p; TempOS.appLaunch("editor") end end
end
