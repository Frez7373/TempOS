local T=dofile("/ui/theme.lua")
term.setTextColor(T.fg); term.setBackgroundColor(T.bg); term.clear(); term.setCursorPos(1,1)
print("TempOS Terminal 1.0.0")
print("Type 'help' for commands. 'exit' returns to desktop.")
local function run(cmd,args)
  if cmd=="help" then print("ls cd mkdir rm cp mv clear edit reboot shutdown wget settings devices network tasks systeminfo update")
  elseif cmd=="ls" then for _,n in ipairs(fs.list(args[1] or "/")) do print(n) end
  elseif cmd=="cd" then print("cd is session-local; use a full path with ls/edit.")
  elseif cmd=="clear" then term.clear(); term.setCursorPos(1,1)
  elseif cmd=="settings" then TempOS.appLaunch("settings")
  elseif cmd=="devices" then TempOS.appLaunch("devices")
  elseif cmd=="network" then TempOS.appLaunch("network")
  elseif cmd=="tasks" then TempOS.appLaunch("taskmanager")
  elseif cmd=="systeminfo" then TempOS.appLaunch("systeminfo")
  elseif cmd=="update" then TempOS.appLaunch("updater")
  elseif cmd=="edit" and args[1] then TempOS.editorPath=args[1]; TempOS.appLaunch("editor")
  elseif cmd=="mkdir" and args[1] then fs.makeDir(args[1])
  elseif cmd=="rm" and args[1] then fs.delete(args[1])
  elseif cmd=="reboot" then os.reboot()
  elseif cmd=="shutdown" then os.shutdown()
  elseif cmd=="cp" and args[1] and args[2] then fs.copy(args[1],args[2])
  elseif cmd=="mv" and args[1] and args[2] then fs.move(args[1],args[2])
  else print("Unknown command. Type help.") end
end
while true do
  write("tempos$ "); local line=read(); local parts={}; for p in line:gmatch("%S+") do table.insert(parts,p) end
  local cmd=table.remove(parts,1); if cmd=="exit" then break end
  if cmd and cmd~="" then local ok,err=xpcall(function() run(cmd,parts) end,debug.traceback); if not ok then printError(err); TempOS.log("crash","terminal\n"..err) end end
end
