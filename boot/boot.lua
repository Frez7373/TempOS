local VERSION = "1.0.1"
local function c(s) return fs.combine("/", s) end
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear(); term.setCursorPos(1,1)
local w,h = term.getSize()
local logo = {"  TTTTT  EEEEE  M   M  PPPP   OOO   SSS  ","    T    E      MM MM  P   P O   O S     ","    T    EEEE   M M M  PPPP  O   O  SSS  ","    T    E      M   M  P     O   O     S ","    T    EEEEE  M   M  P      OOO  SSSS  "}
for i,line in ipairs(logo) do term.setCursorPos(math.max(1, math.floor((w-#line)/2)+1), math.floor(h/2)-3+i); term.write(line) end
term.setCursorPos(2,h-2); term.setTextColor(colors.lightGray); term.write("TempOS BIOS  "..VERSION)
local function step(name, fn)
  term.setCursorPos(2,h-1); term.clearLine(); term.setTextColor(colors.gray); term.write("[ ] "..name)
  local ok,err=xpcall(fn,debug.traceback)
  term.setCursorPos(2,h-1); term.clearLine()
  if ok then term.setTextColor(colors.lime); term.write("[OK] "..name) else term.setTextColor(colors.red); term.write("[FAIL] "..name); fs.makeDir("/tempOS/logs"); local f=fs.open("/tempOS/logs/boot.log","a"); if f then f.writeLine(os.date("!%Y-%m-%dT%H:%M:%SZ").."\n"..err); f.close() end end
  sleep(0.15)
  return ok
end
local ok=true
ok = step("Checking filesystem",function() fs.makeDir("/tempOS"); fs.makeDir("/tempOS/config"); fs.makeDir("/tempOS/data"); fs.makeDir("/tempOS/logs"); fs.makeDir("/tempOS/backups") end) and ok
ok = step("Checking hardware",function() peripheral.getNames() end) and ok
ok = step("Checking network",function() if http and http.checkURL then local okCheck=pcall(http.checkURL,"https://raw.githubusercontent.com"); if not okCheck then error("HTTP API unavailable") end end end) and ok
ok = step("Loading kernel",function() assert(fs.exists("/system/kernel.lua"),"kernel missing") end) and ok
ok = step("Loading drivers",function() assert(fs.exists("/system/peripherals.lua"),"device service missing") end) and ok
ok = step("Starting TempOS",function() end) and ok
sleep(0.4)
if not ok then
  term.setTextColor(colors.yellow); term.setCursorPos(2,h-4); term.write("Startup failed. Press R for recovery or any key to retry.")
  while true do local e,k=os.pullEvent("key"); if k==keys.r then shell.run("/boot/recovery.lua"); return else os.reboot() end end
end
shell.run("/system/kernel.lua")
