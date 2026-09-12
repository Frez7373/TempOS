local T=dofile("/ui/theme.lua")
while true do
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"Device Manager",T.accent2); local devs=TempOS.devices.scan()
  T.text(2,3,"SIDE  TYPE        STATUS",T.muted)
  for i,d in ipairs(devs) do T.text(2,i+4,string.format("%-5s %-11s %s",d.side,d.type,d.online and "ONLINE" or "OFFLINE"),T.text) end
  T.text(2,h,"Press T then a device number to test. [ESC] Exit",T.muted)
  local e,a=os.pullEvent(); if e=="key" and a==keys.esc then break end
  if e=="key" and a==keys.t then term.setCursorPos(2,h-1); write("Device index: "); local n=tonumber(read()); if n and devs[n] then local ok,msg=TempOS.devices.test(devs[n]); print(ok and "Test OK" or ("Test failed: "..tostring(msg))); sleep(1) end end
end
