local T=dofile("/ui/theme.lua")
local expr=""
local function draw()
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"Calculator",T.accent2); T.text(2,4,expr,T.fg)
  local keysSet={{"7","8","9","/"},{"4","5","6","*"},{"1","2","3","-"},{"0",".","=","+"},{"C","(",")","%"}}
  local cw=math.max(6,math.floor((w-3)/4))
  for r,row in ipairs(keysSet) do for c,k in ipairs(row) do local x=2+(c-1)*cw; local y=6+(r-1)*2; T.fill(x,y,x+cw-2,y,T.panel); T.text(x+math.floor((cw-2)/2),y,k,T.fg) end end
  T.text(2,h,"[ESC] Exit",T.muted)
end
draw()
while true do
  local e,a,b,c=os.pullEvent(); local x,y
  if e=="monitor_touch" and a==TempOS.screenSide then x,y=b,c elseif e=="mouse_click" then x,y=b,c end
  if e=="key" and a==keys.esc then break end
  if x and y and y>=6 and y<16 then
    local cw=math.max(6,math.floor((term.getSize()-3)/4)); local col=math.floor((x-2)/cw)+1; local row=math.floor((y-6)/2)+1; local k=keysSet[row] and keysSet[row][col]
    if k then if k=="C" then expr="" elseif k=="=" then local ok,res=pcall(function() return load("return "..expr,"calc","t",{})() end); expr=ok and tostring(res) or "ERR" else expr=expr..k end; draw() end
  end
end
