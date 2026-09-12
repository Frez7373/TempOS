local T=dofile("/tempOS/ui/theme.lua")
local U={}
function U.size() return term.getSize() end
function U.clear() T.apply(); term.clear(); term.setCursorPos(1,1) end
function U.header(title)
  local w=term.getSize(); term.setBackgroundColor(T.panel); term.setTextColor(T.text); term.setCursorPos(1,1); term.clearLine(); write(" TempOS  |  "..tostring(title)); term.setCursorPos(math.max(1,w-5),1); write(textutils.formatTime(os.time(),true)); term.setBackgroundColor(T.bg)
end
function U.footer(label)
  local _,h=term.getSize(); term.setBackgroundColor(T.panel); term.setTextColor(T.text); term.setCursorPos(1,h); term.clearLine(); write(" "..(label or "Touch/Click a button  |  Q: back")); term.setBackgroundColor(T.bg)
end
function U.box(x,y,w,h,title)
  term.setBackgroundColor(T.panel); term.setTextColor(T.text); for yy=y,y+h-1 do term.setCursorPos(x,yy); write(string.rep(" ",w)) end; term.setCursorPos(x+1,y); write(title or ""); term.setBackgroundColor(T.bg)
end
function U.button(x,y,w,label,active)
  label=tostring(label); term.setBackgroundColor(active and T.accent or T.panel); term.setTextColor(colors.white); term.setCursorPos(x,y); write("["..label..string.rep(" ",math.max(0,w-#label-2)).."]"); term.setBackgroundColor(T.bg)
end
function U.hit(x,y,w,h,tx,ty) return tx>=x and tx<x+w and ty>=y and ty<y+h end
function U.wrap(text,width)
  local out={}; for line in tostring(text):gmatch("[^\n]*") do while #line>width do table.insert(out,line:sub(1,width)); line=line:sub(width+1) end; table.insert(out,line) end; return out
end
function U.message(title,msg)
  local _,h=term.getSize(); U.clear(); U.header(title); local lines=U.wrap(msg,term.getSize()-4); for i,l in ipairs(lines) do if i<h-3 then term.setCursorPos(2,i+2); print(l) end end; U.button(math.max(2,math.floor(term.getSize()/2)-8),h-2,16,"CONTINUE",true); U.footer("Touch/click or any key")
  while true do local e=os.pullEvent(); if e=="key" or e=="monitor_touch" or e=="mouse_click" then return end end
end
function U.input(title,prompt,default)
  local w=term.getSize(); local value=default or ""
  local function draw()
    U.clear(); U.header(title); term.setCursorPos(2,3); print(prompt); term.setBackgroundColor(T.panel); term.setCursorPos(2,5); write(string.rep(" ",w-3)); term.setCursorPos(3,5); term.setTextColor(T.text); write(value:sub(math.max(1,#value-w+5))); term.setBackgroundColor(T.bg)
    local digits="1234567890"; local y=7; local bw=math.max(4,math.floor((w-4)/10)); for i=1,#digits do U.button(2+(i-1)*bw,y,bw,digits:sub(i,i),false) end
    local rows={"qwertyuiop","asdfghjkl","zxcvbnm"}; for r,row in ipairs(rows) do local bw2=math.max(4,math.floor((w-4)/#row)); for i=1,#row do U.button(2+(i-1)*bw2,y+r*2,bw2,row:sub(i,i),false) end end
    U.button(2,y+8,math.floor(w/3),"SPACE",false); U.button(3+math.floor(w/3),y+8,math.floor(w/3),"BACK",false); U.button(4+2*math.floor(w/3),y+8,w-(4+2*math.floor(w/3)),"DONE",true); U.footer("Keyboard also supported")
  end
  draw()
  while true do
    local e,a,b,c=os.pullEvent()
    if e=="char" then value=value..a; draw()
    elseif e=="key" then if a==keys.enter then return value elseif a==keys.backspace then value=value:sub(1,-2); draw() elseif a==keys.escape then return nil end
    elseif e=="monitor_touch" or e=="mouse_click" then
      local x,y=b,c; local yy=7; local digits="1234567890"; local bw=math.max(4,math.floor((w-4)/10))
      for i=1,#digits do local xx=2+(i-1)*bw; if U.hit(xx,yy,bw,1,x,y) then value=value..digits:sub(i,i); draw() end end
      local rows={"qwertyuiop","asdfghjkl","zxcvbnm"}; for r,row in ipairs(rows) do local yy2=yy+r*2; local bw2=math.max(4,math.floor((w-4)/#row)); for i=1,#row do local xx=2+(i-1)*bw2; if U.hit(xx,yy2,bw2,1,x,y) then value=value..row:sub(i,i); draw() end end end
      if U.hit(2,yy+8,math.floor(w/3),1,x,y) then value=value.." "; draw() end
      if U.hit(3+math.floor(w/3),yy+8,math.floor(w/3),1,x,y) then value=value:sub(1,-2); draw() end
      if U.hit(4+2*math.floor(w/3),yy+8,w-(4+2*math.floor(w/3)),1,x,y) then return value end
    end
  end
end
return U
