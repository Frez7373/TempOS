local T=dofile("/ui/theme.lua")
local W=dofile("/ui/widgets.lua")
local M={}
local function draw(ops)
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg)
  T.fill(1,1,w,2,T.panel); T.text(2,1,"TempOS",T.fg); T.text(w-8,1,textutils.formatTime(os.time(),true),T.fg)
  local online=TempOS.network.online; T.text(math.max(2,w-28),1,online and "NET: ONLINE" or "NET: OFFLINE",online and T.success or T.danger)
  T.fill(1,h-1,w,h,T.panel); T.text(2,h,"[MENU]",T.accent2); T.text(math.floor(w/2)-4,h,"TempOS 1.0.0",T.muted); T.text(w-8,h,"[OFF]",T.danger)
  local x,y=2,4; local ids={}; for id in pairs(TempOS.apps) do table.insert(ids,id) end; table.sort(ids)
  for _,id in ipairs(ids) do local a=TempOS.apps[id]; if x+15>w then x=2; y=y+3 end; ops[id]=W.button(x,y,15,"[ "..a.icon.." ] "..a.name,true); x=x+16 end
end
function M.run()
  while true do
    local hit={}; draw(hit); local timer=os.startTimer(1)
    while true do
      local e,a,b,c=os.pullEvent()
      if e=="timer" and a==timer then break
      elseif e=="monitor_touch" then
        if a==TempOS.screenSide then local x,y=b,c; for id,r in pairs(hit) do if W.hit(r,x,y) then local ok,err=TempOS.appLaunch(id); if not ok then TempOS.log("crash",id.."\n"..err); term.clear(); term.setCursorPos(2,2); term.setTextColor(T.danger); print("Application Error"); print(id.." stopped unexpectedly."); print("Press any key to return."); os.pullEvent("key") end; break end end end
      elseif e=="mouse_click" then
        local x,y=b,c; if y==term.getSize() and x>=term.getSize()-10 then TempOS.shutdown(false) end
        for id,r in pairs(hit) do if W.hit(r,x,y) then local ok,err=TempOS.appLaunch(id); if not ok then TempOS.log("crash",id.."\n"..err); printError(err); os.pullEvent("key") end; break end end
      elseif e=="key" and a==keys.f4 then TempOS.shutdown(false)
      elseif e=="term_resize" then break
      end
    end
  end
end
return M
