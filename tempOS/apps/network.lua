local ui=dofile("/tempOS/ui/ui.lua")
local N=dofile("/tempOS/system/network.lua")
local function run()
  while true do
    local i=N.info(); ui.clear(); ui.header("Network"); term.setCursorPos(2,3); print("Status: "..(i.open and "ONLINE" or "OFFLINE")); print("Computer ID: "..i.computerId); print("Modems:"); for n,m in ipairs(i.modems) do print("  "..m.."  "..tostring(peripheral.getType(m))) end
    ui.button(2,10,18,"Connect",false); ui.button(22,10,18,"Broadcast",false); ui.button(42,10,14,"Back",true); ui.footer("Touch/click or Q")
    local e,a,b,c=os.pullEvent(); if e=="key" and a==keys.q then return elseif e=="monitor_touch" or e=="mouse_click" then local x,y=b,c
      if ui.hit(2,10,18,1,x,y) then local ok,err=N.open(); ui.message("Network",ok and "Network initialized." or tostring(err))
      elseif ui.hit(22,10,18,1,x,y) then local v=ui.input("Broadcast","Message:",""); if v then local ok,err=N.broadcast(v,"tempos"); ui.message("Network",ok and "Message sent." or tostring(err)) end
      elseif ui.hit(42,10,14,1,x,y) then return end
    end
  end
end
run()
