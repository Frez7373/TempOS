local ui=dofile("/tempOS/ui/ui.lua")
local S=dofile("/tempOS/system/security.lua")
local function run()
  while true do
    ui.clear(); ui.header("Security Center"); term.setCursorPos(2,3); print("System: Protected"); print("Integrity engine: active"); print(""); ui.button(2,7,18,"Quick Scan",false); ui.button(22,7,18,"Check Core",false); ui.button(42,7,14,"Back",true); ui.footer("Touch/click or Q")
    local e,a,b,c=os.pullEvent(); if e=="key" and a==keys.q then return elseif e=="monitor_touch" or e=="mouse_click" then local x,y=b,c
      if ui.hit(2,7,18,1,x,y) then local r=S.quickScan("/"); ui.message("Quick Scan","Checked: "..r.checked.."\nSuspicious: "..#r.suspicious) elseif ui.hit(22,7,18,1,x,y) then local ok,h,n=S.checkFile("/tempOS/kernel/kernel.lua"); ui.message("Core Check",ok and ("Kernel fingerprint: "..h.."\nBytes: "..n) or tostring(h)) elseif ui.hit(42,7,14,1,x,y) then return end
    end
  end
end
run()
