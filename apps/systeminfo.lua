local T=dofile("/ui/theme.lua")
while true do
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"System Information",T.accent2)
  local info={"TempOS 1.0.0","Minecraft target: 1.16.5","Computer ID: "..os.getComputerID(),"Label: "..(os.getComputerLabel() or "none"),"Uptime: "..math.floor((os.epoch("utc")-TempOS.boot)/1000).."s","Lua memory: "..math.floor(collectgarbage("count")).." KB","Storage free: "..tostring(fs.getFreeSpace("/")).." bytes","Network: "..(TempOS.network.online and "ONLINE" or "OFFLINE"),"Screen: "..tostring(TempOS.screenSide),"Devices: "..#TempOS.devices.devices}
  for i,s in ipairs(info) do if i+4<h then T.text(3,i+4,s,T.fg) end end; T.text(2,h,"[ESC] Exit",T.muted)
  local e,a=os.pullEvent(); if e=="key" and a==keys.esc then break end
end
