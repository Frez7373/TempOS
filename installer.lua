-- TempOS installer 1.0.0
-- Run: wget run https://raw.githubusercontent.com/Frez7373/TempOS/main/installer.lua
local BASE = "https://raw.githubusercontent.com/Frez7373/TempOS/main/"
local files = {
  "tempOS/boot/loader.lua","tempOS/kernel/kernel.lua","tempOS/libraries/util.lua","tempOS/libraries/log.lua","tempOS/ui/theme.lua","tempOS/ui/ui.lua","tempOS/system/network.lua","tempOS/system/devices.lua","tempOS/system/security.lua","tempOS/system/settings.lua","tempOS/system/apps.lua","tempOS/apps/desktop.lua","tempOS/apps/settings.lua","tempOS/apps/files.lua","tempOS/apps/terminal.lua","tempOS/apps/editor.lua","tempOS/apps/calculator.lua","tempOS/apps/clock.lua","tempOS/apps/devices.lua","tempOS/apps/network.lua","tempOS/apps/taskmgr.lua","tempOS/apps/security.lua","tempOS/apps/update.lua","tempOS/apps/package.lua","tempOS/recovery/recovery.lua","tempOS/data/config.lua","README.md","VERSION"
}
term.clear(); term.setCursorPos(1,1); print("TempOS Installer 1.0.0"); print("Checking HTTP support...")
if not http or not http.get then print("HTTP is unavailable. Enable HTTP in CC:Tweaked config."); return end
local function mkdirFor(path) local p=fs.getDir(path); if p and p~="" then fs.makeDir("/"..p:gsub("^/","")) end end
local function download(path)
  mkdirFor(path); local h,err=http.get(BASE..path,nil,true); if not h then return false,tostring(err) end; local data=h.readAll(); h.close(); if not data or #data==0 then return false,"empty response" end; local f=fs.open("/"..path,"w"); if not f then return false,"cannot open target" end; f.write(data); f.close(); return true
end
for i,path in ipairs(files) do write(string.format("[%02d/%02d] %s ",i,#files,path)); local ok,err=download(path); if ok then print("OK") else print("FAILED: "..err); return end end
if fs.exists("/tempOS/data/config.lua") then local f=fs.open("/tempOS/data/installed","w"); f.write("TempOS 1.0.0"); f.close() end
print(""); print("TempOS installed successfully."); print("Rebooting..."); os.sleep(1); os.reboot()
