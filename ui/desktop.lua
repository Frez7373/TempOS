local T=dofile("/ui/theme.lua")
local W=dofile("/ui/widgets.lua")
local M={}
local function draw(ops)
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg)
  T.fill(1,1,w,2,T.panel); T.text(2,1,"TempOS",T.text); T.text(w-8,1,textutils.formatTime(os.time(),true),T.text)
  local online=TempOS.network.online
  T.text(math.max(2,w-28),1,online and "NET: ONLINE" or "NET: OFFLINE",online and T.success or T.danger)
  T.fill(1,h-1,w,h,T.panel); T.text(2,h,"[MENU]",T.accent2); T.text(math.floor(w/2)-4,h,"TempOS 1.0.0",T.muted); T.text(w-8,h,"[OFF]",T.danger)
  local x,y=2,4
  for id,a in pairs(TempOS.apps) do
    if x+15>w then x=2; y=y+3 end
    local b=W.button(x,y,15,"[ "..a.icon.." ] "..a.name,true); ops[id]=b; x=x+16
  end
end
function M.run()
  local old=term.current(); local menu=false
  while true do
    local hit={}; draw(hit)
    local timer=os.startTimer(1)
    while true do
      local e,a,b=os.pullEvent()
      if e=="timer" and a==timer then break end
      if e=="monitor_touch" then
        if a~=TempOS.screenSide then goto continue end
        if b>=4 then for id,r in pairs(hit) do if W.hit(r,b,c) then local ok,err=TempOS.appLaunch(id); if not ok then TempOS.notify("Application error: "..err,"error") end; break end end end
      elseif e=="mouse_click" then
        local x1,y1=b,c
        if y1==term.getSize() and x1>=term.getSize()-10 then TempOS.shutdown(false) end
        if y1>=4 then for id,r in pairs(hit) do if W.hit(r,x1,y1) then local ok,err=TempOS.appLaunch(id); if not ok then TempOS.notify("Application error: "..err,"error") end; break end end end
      elseif e=="key" and a==keys.f4 then TempOS.shutdown(false)
      elseif e=="term_resize" then break
      end
      ::continue::
    end
  end
  term.redirect(old)
end
return M
