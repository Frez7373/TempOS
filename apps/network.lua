local T=dofile("/ui/theme.lua")
while true do
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"Network",T.accent2)
  local lines={"Status: "..(TempOS.network.online and "ONLINE" or "OFFLINE"),"Modem: "..tostring(TempOS.network.side or "none"),"Computer ID: "..os.getComputerID(),"Channel: 42","Sent packets: "..tostring(TempOS.network.sent or 0),"Received packets: "..tostring(TempOS.network.received or 0)}
  for i,s in ipairs(lines) do T.text(3,i+4,s,T.text) end; T.text(2,h,"[P] ping broadcast  [R] rescan  [ESC] exit",T.muted)
  local e,a=os.pullEvent(); if e=="key" and a==keys.esc then break end
  if e=="key" and a==keys.r then TempOS.devices.scan(); TempOS.network.init() end
  if e=="key" and a==keys.p then TempOS.network.broadcast({action="ping"}); T.text(3,h-2,"Ping sent",T.success); sleep(1) end
end
