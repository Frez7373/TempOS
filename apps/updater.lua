local T=dofile("/ui/theme.lua")
local BASE="https://raw.githubusercontent.com/Frez7373/TempOS/main/"; local MAN="manifest.lua"
term.clear(); term.setCursorPos(1,1); T.text(1,1,"TempOS Updater",T.accent2); print("Checking for updates...")
local r=http.get(BASE..MAN); if not r then print("Update server unavailable."); os.pullEvent("key"); return end
local f=r.readAll(); r.close(); local ok,m=pcall(function() return load(f,"manifest","t",{})() end); if not ok or type(m)~="table" then print("Invalid update manifest."); os.pullEvent("key"); return end
print("Remote version: "..tostring(m.version)); print("Current version: "..TempOS.version); print("Press Y to update, N to cancel.")
local e,k=os.pullEvent("key"); if k~=keys.y then return end
fs.makeDir("/tempOS/backups/"..os.date("%Y%m%d%H%M%S")); local backup="/tempOS/backups/"..os.date("%Y%m%d%H%M%S")
for _,p in ipairs(m.files) do if fs.exists(p) then fs.copy(p,fs.combine(backup,p)); end end
for _,p in ipairs(m.files) do local q=http.get(BASE..p); if q then local data=q.readAll(); q.close(); fs.makeDir(fs.getDir(p)); local h=fs.open(p,"w"); h.write(data); h.close(); end end
print("Update complete. Reboot now? Y/N"); while true do local ev,key=os.pullEvent("key"); if key==keys.y then os.reboot() elseif key==keys.n then return end end
