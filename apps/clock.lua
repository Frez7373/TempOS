local T=dofile("/ui/theme.lua")
while true do
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); local tm=textutils.formatTime(os.time(),true); local line="  "..tm.."  "; local x=math.max(1,math.floor((w-#line)/2)); local y=math.max(3,math.floor(h/2)); T.text(x,y,line,T.accent2); T.text(2,h,"[ESC] Exit",T.muted)
  local e,a=os.pullEvent(); if e=="key" and a==keys.esc then break end
end
