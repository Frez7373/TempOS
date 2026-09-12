local T=require("ui.theme")
local M={}
function M.button(x,y,w,label,active) T.fill(x,y,x+w-1,y,active and T.accent or T.panel); T.text(x+1,y,(label or ""):sub(1,w-2),T.text); return {x=x,y=y,w=w,h=1} end
function M.hit(b,tx,ty) return tx>=b.x and tx<b.x+b.w and ty>=b.y and ty<=b.y+b.h-1 end
function M.box(x1,y1,x2,y2,title) T.fill(x1,y1,x2,y2,T.panel); if title then T.text(x1+1,y1," "..title.." ",T.accent2) end end
function M.progress(x,y,w,value) T.fill(x,y,x+w-1,y,colors.gray); local n=math.floor(w*math.max(0,math.min(1,value))); if n>0 then T.fill(x,y,x+n-1,y,T.accent) end end
function M.wrap(text,w) local lines={}; for part in tostring(text):gmatch("[^\n]+") do while #part>w do table.insert(lines,part:sub(1,w)); part=part:sub(w+1) end; table.insert(lines,part) end; return lines end
return M
