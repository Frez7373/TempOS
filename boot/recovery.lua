term.setBackgroundColor(colors.black); term.setTextColor(colors.white); term.clear(); term.setCursorPos(1,1)
print("TEMP OS RECOVERY 1.0.0"); print("1) Start TempOS"); print("2) Safe Mode"); print("3) Repair System"); print("4) Factory Reset"); print("5) Open Terminal"); print("6) View Logs"); print("7) Reinstall System"); print("8) Shutdown")
write("Select: "); local n=read()
if n=="1" then shell.run("/boot/boot.lua")
elseif n=="2" then shell.run("/system/safemode.lua")
elseif n=="3" then fs.makeDir("/tempOS/logs"); print("Repair: directories recreated."); print("Press a key."); os.pullEvent("key"); shell.run("/boot/recovery.lua")
elseif n=="4" then print("Type RESET to confirm full TempOS data reset:"); if read()=="RESET" then fs.delete("/tempOS"); fs.makeDir("/tempOS"); fs.makeDir("/tempOS/config"); print("Reset complete. Rebooting."); sleep(1); os.reboot() else print("Cancelled."); sleep(1); shell.run("/boot/recovery.lua") end
elseif n=="5" then shell.run("/bin/recovery-shell.lua")
elseif n=="6" then local p="/tempOS/logs"; print("Logs:"); if fs.exists(p) then for _,f in ipairs(fs.list(p)) do print("- "..f) end end; os.pullEvent("key"); shell.run("/boot/recovery.lua")
elseif n=="7" then print("Use the network installer from the recovery terminal to reinstall files."); os.pullEvent("key"); shell.run("/boot/recovery.lua")
else os.shutdown() end
