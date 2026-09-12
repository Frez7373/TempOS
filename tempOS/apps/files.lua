local ui=dofile("/tempOS/ui/ui.lua")
local U=dofile("/tempOS/libraries/util.lua")
local function run()
  local dir="/"
  while true do
    ui.clear(); ui.header("Files"); local w,h=term.getSize(); local list=fs.list(dir); local rows={}
    for i,n in ipairs(list) do if i<=h-7 then rows[i]=n end end
    term.setCursorPos(2,3); print("Path: "..dir)
    for i,n in ipairs(rows) do local p=fs.combine(dir,n); term.setCursorPos(2,3+i); print((fs.isDir(p) and "[DIR] " or "      ")..n) end
    ui.button(2,h-3,14,"Open",false); ui.button(17,h-3,14,"New folder",false); ui.button(32,h-3,14,"Remove",false); ui.button(47,h-3,12,"Back",true); ui.footer("Select a row, then Open/Remove")
    local e,a,b,c=os.pullEvent(); if e=="key" and a==keys.q then return elseif e=="mouse_click" or e=="monitor_touch" then local x,y=b,c
      if y>=4 and y<4+#rows then local n=rows[y-3]; local p=fs.combine(dir,n)
        if ui.hit(2,h-3,14,1,x,y) then if fs.isDir(p) then dir=p else ui.message(n,U.readAll(p) or "") end
        elseif ui.hit(32,h-3,14,1,x,y) then ui.message("File Manager","Removal is disabled for system safety in TempOS 1.0.0.") end
      elseif ui.hit(17,h-3,14,1,x,y) then local n=ui.input("New folder","Folder name:",""); if n and n~="" then fs.makeDir(fs.combine(dir,n)) end
      elseif ui.hit(47,h-3,12,1,x,y) then if dir~="/" then dir=fs.getDir(dir); if dir=="" then dir="/" end else return end end
    end
  end
end
run()
