local ui=dofile("/tempOS/ui/ui.lua")
local function resetSettings()
  local f=fs.open("/tempOS/data/config.lua","w"); if f then f.write([[return {version="1.0.0",name="TempOS",computerName="TempComputer",theme="default",lockEnabled=false,password="",updateURL="https://raw.githubusercontent.com/Frez7373/TempOS/main/"}]]) f.close(); return true end return false end
local function run()
  while true do
    ui.clear(); ui.header("Recovery"); print("TempOS Recovery"); print(""); ui.button(2,6,22,"Boot TempOS",false); ui.button(26,6,22,"Safe Mode",false); ui.button(2,8,22,"Repair System",false); ui.button(26,8,22,"Reset Settings",false); ui.button(2,10,22,"Factory Reset",false); ui.button(26,10,22,"Shutdown",true); ui.footer("Touch/click or keyboard")
    local e,a,b,c=os.pullEvent(); if e=="key" then if a==keys.b then return elseif a==keys.q then os.shutdown() end elseif e=="monitor_touch" or e=="mouse_click" then local x,y=b,c
      if ui.hit(2,6,22,1,x,y) then return elseif ui.hit(26,6,22,1,x,y) then ui.message("Safe Mode","Safe Mode starts with the desktop only. Reboot after diagnosis."); return elseif ui.hit(2,8,22,1,x,y) then local ok=fs.exists("/tempOS/kernel/kernel.lua") and fs.exists("/tempOS/ui/ui.lua"); ui.message("Repair System",ok and "Core files are present." or "Core files are missing.") elseif ui.hit(26,8,22,1,x,y) then resetSettings(); ui.message("Recovery","Settings reset.") elseif ui.hit(2,10,22,1,x,y) then local v=ui.input("Factory Reset","Type FACTORY to confirm:",""); if v=="FACTORY" then fs.delete("/tempOS/data"); fs.makeDir("/tempOS/data"); resetSettings(); ui.message("Recovery","User data and settings reset. Rebooting..."); os.reboot() end elseif ui.hit(26,10,22,1,x,y) then os.shutdown() end end
  end
end
run()
