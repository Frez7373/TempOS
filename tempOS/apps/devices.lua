local ui=dofile("/tempOS/ui/ui.lua")
local D=dofile("/tempOS/system/devices.lua")
local function run()
  ui.clear(); ui.header("Devices"); local list=D.scan(); local _,h=term.getSize(); if #list==0 then term.setCursorPos(2,3); print("No peripherals detected.") end
  for i,d in ipairs(list) do if i<=h-5 then term.setCursorPos(2,2+i); print(d.name.."  ["..tostring(d.type).."]") end end
  ui.footer("Press any key to return"); os.pullEvent("key")
end
run()
