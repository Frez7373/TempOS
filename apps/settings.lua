local T=dofile("/ui/theme.lua")
local function save() TempOS.saveSettings() end
local function draw(rows)
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"Settings",T.accent2); T.text(w-12,2,"[ESC]",T.muted)
  for i,r in ipairs(rows) do local y=4+(i-1)*2; T.fill(3,y,w-2,y,T.panel); T.text(4,y,r.label,T.text); T.text(math.max(18,w-12),y,tostring(r.value),T.accent) end
end
local rows={{label="Computer name",value=TempOS.settings.computerName},{label="Network",value=TempOS.network.online and "ONLINE" or "OFFLINE"},{label="Sound",value=TempOS.settings.sounds and "ON" or "OFF"},{label="Lock minutes",value=TempOS.settings.lockMinutes},{label="Factory reset",value="Recovery"}}
draw(rows)
while true do
  local e,a,b,c=os.pullEvent(); local x,y
  if e=="monitor_touch" and a==TempOS.screenSide then x,y=b,c elseif e=="mouse_click" then x,y=b,a end
  if e=="key" and a==keys.esc then break end
  if x and y then
    if y==4 then term.setCursorPos(20,4); term.setTextColor(T.accent); term.write("Name: "); local v=read(); if v~="" then TempOS.settings.computerName=v; rows[1].value=v; save(); draw(rows) end
    elseif y==8 then TempOS.settings.sounds=not TempOS.settings.sounds; rows[3].value=TempOS.settings.sounds and "ON" or "OFF"; save(); draw(rows)
    elseif y==10 then term.clear(); term.setCursorPos(2,2); term.setTextColor(T.text); print("Factory reset is available from Recovery Mode."); print("Press any key to return."); os.pullEvent("key"); draw(rows) end
  end
end
