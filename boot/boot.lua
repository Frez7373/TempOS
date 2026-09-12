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
    if key == keys.r then shell.run("/boot/recovery.lua"); return end
    if key == keys.q then os.shutdown(); return end
  end
end
