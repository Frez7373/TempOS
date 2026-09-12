local ui=dofile("/tempOS/ui/ui.lua")
local S=dofile("/tempOS/system/settings.lua")
local function run()
  while true do
    local c=S.get(); ui.clear(); ui.header("Settings"); local w,h=term.getSize();
    print(" Computer: "..tostring(c.computerName)); print(" ID: "..os.getComputerID()); print(" Version: "..tostring(c.version)); print(" Network: "); print(" Security lock: "..tostring(c.lockEnabled)); print("")
    ui.button(2,8,24,"Computer name",false); ui.button(28,8,24,"Password",false); ui.button(2,10,24,"Toggle lock",false); ui.button(28,10,24,"System info",false); ui.button(2,12,24,"Factory reset",false); ui.button(28,12,24,"Back",true); ui.footer("Touch/click or press Q")
    local e,a,b,c2=os.pullEvent(); local x,y
    if e=="key" and a==keys.q then return elseif e=="monitor_touch" or e=="mouse_click" then x,y=b,c2
      if ui.hit(2,8,24,1,x,y) then local v=ui.input("Computer name","Enter a name:",c.computerName); if v and v~="" then c.computerName=v; S.save(c); pcall(os.setComputerLabel,v) end
      elseif ui.hit(28,8,24,1,x,y) then local v=ui.input("Password","Enter a new password:",""); if v then c.password=v; c.lockEnabled=#v>0; S.save(c) end
      elseif ui.hit(2,10,24,1,x,y) then c.lockEnabled=not c.lockEnabled; S.save(c)
      elseif ui.hit(28,10,24,1,x,y) then ui.message("System Information","TempOS "..c.version.."\nComputer ID: "..os.getComputerID().."\nLabel: "..(os.getComputerLabel() or "").."\nTerminal: "..term.getSize().."\nFree space: "..tostring(fs.getFreeSpace("/")))
      elseif ui.hit(2,12,24,1,x,y) then local v=ui.input("Factory Reset","Type RESET to confirm:",""); if v=="RESET" then fs.delete("/tempOS/data/config.lua"); fs.copy("/tempOS/data/config.lua","/tempOS/data/config.lua") end
      elseif ui.hit(28,12,24,1,x,y) then return end
    end
  end
end
run()
