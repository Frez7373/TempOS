local T=dofile("/tempOS/ui/theme.lua")
local U={}
function U.size() return term.getSize() end
function U.clear() T.apply(); term.clear(); term.setCursorPos(1,1) end
function U.header(title)
  local w,h=term.getSize(); term.setBackgroundColor(T.panel); term.setTextColor(T.text); term.clearLine(); term.setCursorPos(1,1); write(" TempOS  |  "..tostring(title)); term.setCursorPos(math.max(1,w-5),1); write(textutils.formatTime(os.time(),true)); term.setBackgroundColor(T.bg)
end
function U.footer(label)
  local w,h=term.getSize(); term.setBackgroundColor(T.panel); term.setCursorPos(1,h); term.clearLine(); write(" "..(label or "Touch/Click a button  |  Q: back")); term.setBackgroundColor(T.bg)
end
function U.box(x,y,w,h,title)
  term.setBackgroundColor(T.panel); term.setTextColor(T.text); for yy=y,y+h-1 do term.setCursorPos(x,yy); write(string.rep(" ",w)) end
  term.setCursorPos(x+1,y); write(title or "")
  term.setBackgroundColor(T.bg)
end
function U.button(x,y,w,label,active)
  term.setBackgroundColor(active and T.accent or T.panel); term.setTextColor(colors.white); term.setCursorPos(x,y); write("["..label..string.rep(" ",math.max(0,w-#label-2)).."]"); term.setBackgroundColor(T.bg)
end
function U.hit(x,y,w,h,tx,ty) return tx>=x and tx<x+w and ty>=y and ty<y+h end
function U.wrap(text,width)
  local out={}; for line in tostring(text):gmatch("[^\n]*") do
    while #line>width do table.insert(out,line:sub(1,width)); line=line:sub(width+1) end
    table.insert(out,line)
  end return out
end
function U.message(title,msg)
  local w,h=term.getSize(); U.clear(); U.header(title); local lines=U.wrap(msg,w-4); for i,l in ipairs(lines) do if i<h-3 then term.setCursorPos(2,i+2); print(l) end end; U.footer("Press any key"); os.pullEvent("key")
end
return U
