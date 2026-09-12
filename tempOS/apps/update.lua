local ui=dofile("/tempOS/ui/ui.lua")
local S=dofile("/tempOS/system/settings.lua")
local files={"tempOS/boot/loader.lua","tempOS/kernel/kernel.lua","tempOS/libraries/util.lua","tempOS/libraries/log.lua","tempOS/ui/theme.lua","tempOS/ui/ui.lua","tempOS/system/network.lua","tempOS/system/devices.lua","tempOS/system/security.lua","tempOS/system/settings.lua","tempOS/system/apps.lua","tempOS/apps/desktop.lua","tempOS/apps/settings.lua","tempOS/apps/files.lua","tempOS/apps/terminal.lua","tempOS/apps/textedit.lua","tempOS/apps/calculator.lua","tempOS/apps/clock.lua","tempOS/apps/devices.lua","tempOS/apps/network.lua","tempOS/apps/taskmgr.lua","tempOS/apps/security.lua","tempOS/apps/update.lua","tempOS/apps/package.lua","tempOS/recovery/recovery.lua"}
local function run()
 while true do
  local c=S.get(); ui.clear(); ui.header("Update Manager"); print("Current version: "..tostring(c.version)); print(""); ui.button(2,7,20,"Check online",false); ui.button(24,7,20,"Install latest",false); ui.button(46,7,10,"Back",true); ui.footer("Touch/click or Q")
  local e,a,b,d=os.pullEvent(); if e=="key" and a==keys.q then return elseif e=="monitor_touch" or e=="mouse_click" then local x,y=b,d
   if ui.hit(2,7,20,1,x,y) then if not http or not http.get then ui.message("Updates","HTTP is disabled.") else local h,err=http.get(c.updateURL.."VERSION",nil,true); if h then local v=h.readAll(); h.close(); ui.message("Updates","Remote version: "..v.."\nLocal version: "..tostring(c.version)) else ui.message("Updates",tostring(err)) end end
   elseif ui.hit(24,7,20,1,x,y) then
    if not http or not http.get then ui.message("Updates","HTTP is disabled.") else
     fs.makeDir("/tempOS/data/backup"); local ok=true; local errMsg=""
     for _,p in ipairs(files) do local old="/tempOS/data/backup/old_"..p; fs.makeDir(fs.getDir(old)); if fs.exists("/"..p) then local f=fs.open("/"..p,"r"); local d=f.readAll(); f.close(); local bkp=fs.open(old,"w"); if bkp then bkp.write(d); bkp.close() else ok=false; errMsg="backup failed: "..p; break end end end
     if ok then for _,p in ipairs(files) do local h,err=http.get(c.updateURL..p,nil,true); if not h then ok=false; errMsg=tostring(err); break end; local d=h.readAll(); h.close(); local f=fs.open("/"..p,"w"); if not f then ok=false; errMsg="write failed: "..p; break end; f.write(d); f.close() end end
     if ok then c.version="1.0.0"; S.save(c); ui.message("Updates","Update completed. Backup is in /tempOS/data/backup.") else ui.message("Updates","Update stopped safely. Restore files from /tempOS/data/backup if required.\n"..errMsg) end
    end
   elseif ui.hit(46,7,10,1,x,y) then return end
  end
 end
end
run()
