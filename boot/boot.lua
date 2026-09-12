local ok, err = pcall(dofile, "/boot/bootloader.lua")
if not ok then
  pcall(fs.makeDir, "/tempOS/logs")
  local f = fs.open("/tempOS/logs/boot.log", "a")
  if f then f.writeLine(tostring(err)); f.close() end
  term.setBackgroundColor(colors.black)
  term.clear(); term.setCursorPos(1,1)
  term.setTextColor(colors.red)
  print("TempOS Bootloader Error")
  print("")
  print(tostring(err))
  print("")
  print("[R] Recovery  [Q] Shutdown")
  while true do
    local _, key = os.pullEvent("key")
    if key == keys.r then
      local fn, loadErr = loadfile("/boot/recovery.lua")
      if fn then
        local rok, runErr = pcall(fn)
        if not rok then print("Recovery error: " .. tostring(runErr)) end
      else
        print("Recovery missing: " .. tostring(loadErr))
      end
      return
    end
    if key == keys.q then os.shutdown(); return end
  end
end
