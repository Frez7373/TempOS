-- TempOS Bootloader 1.0.0
local VERSION = "1.0.0"
local w,h = term.getSize()
local logPath = "/tempOS/logs/boot.log"

local function log(message)
  pcall(fs.makeDir, "/tempOS/logs")
  local f = fs.open(logPath, "a")
  if f then
    f.writeLine(os.date("!%Y-%m-%dT%H:%M:%SZ") .. " " .. tostring(message))
    f.close()
  end
end

local function runFile(path)
  if not fs.exists(path) then
    return false, "missing file: " .. path
  end
  local fn, err = loadfile(path)
  if not fn then return false, err end
  local ok, result = xpcall(fn, debug and debug.traceback or function(e) return tostring(e) end)
  if not ok then return false, result end
  return true, result
end

local function redraw()
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
  term.setTextColor(colors.cyan)
  print("TEMP BIOS")
  term.setTextColor(colors.white)
  print("TempOS Bootloader " .. VERSION)
  print("")
end

local function stage(label, fn)
  local _, y = term.getCursorPos()
  term.setCursorPos(1, y)
  term.setTextColor(colors.lightGray)
  write("[   ] " .. label)
  local ok, err = xpcall(fn, debug and debug.traceback or function(e) return tostring(e) end)
  term.setCursorPos(1, y)
  term.clearLine()
  term.setTextColor(ok and colors.lime or colors.red)
  write(ok and "[ OK ] " .. label or "[FAIL] " .. label)
  term.setTextColor(colors.white)
  if not ok then log(label .. ": " .. tostring(err)) end
  sleep(0.15)
  return ok
end

local function recovery()
  term.setTextColor(colors.yellow)
  print("")
  print("Boot checks failed.")
  print("[R] Recovery  [Q] Shutdown")
  while true do
    local _, key = os.pullEvent("key")
    if key == keys.r then
      local ok, err = runFile("/boot/recovery.lua")
      if not ok then
        term.setTextColor(colors.red)
        print("Recovery failed: " .. tostring(err))
        print("Press any key to reboot.")
        os.pullEvent("key")
        os.reboot()
      end
      return
    elseif key == keys.q then
      os.shutdown()
    end
  end
end

redraw()
print("Checking hardware...")
local ok = true
ok = stage("Filesystem", function()
  fs.makeDir("/tempOS")
  fs.makeDir("/tempOS/config")
  fs.makeDir("/tempOS/data")
  fs.makeDir("/tempOS/logs")
  fs.makeDir("/tempOS/backups")
end) and ok
ok = stage("Peripherals", function() peripheral.getNames() end) and ok
ok = stage("Kernel", function() assert(fs.exists("/system/kernel.lua"), "kernel.lua missing") end) and ok
ok = stage("Desktop", function() assert(fs.exists("/ui/desktop.lua"), "desktop.lua missing") end) and ok
ok = stage("Recovery", function() assert(fs.exists("/boot/recovery.lua"), "recovery.lua missing") end) and ok
ok = stage("Network", function()
  if fs.exists("/system/network.lua") then
    local fn = assert(loadfile("/system/network.lua"))
    local success, err = xpcall(fn, debug and debug.traceback or function(e) return tostring(e) end)
    assert(success, err)
  end
end) and ok

local barY = math.min(h - 2, 12)
local total = math.max(1, w - 4)
for i = 1, total do
  term.setCursorPos(2, barY)
  term.setTextColor(colors.gray)
  write("[")
  term.setTextColor(colors.cyan)
  write(string.rep("#", i))
  term.setTextColor(colors.gray)
  write(string.rep("-", total - i))
  write("]")
  sleep(0.02)
end

if not ok then
  recovery()
  return
end

term.setTextColor(colors.lime)
print("")
print("Starting TempOS...")
sleep(0.25)

local success, err = runFile("/system/kernel.lua")
if not success then
  log("Kernel: " .. tostring(err))
  term.setTextColor(colors.red)
  print("Kernel failed to start.")
  print(tostring(err))
  print("")
  print("[R] Recovery  [Q] Shutdown")
  while true do
    local _, key = os.pullEvent("key")
    if key == keys.r then
      local rok, rerr = runFile("/boot/recovery.lua")
      if not rok then print("Recovery failed: " .. tostring(rerr)) end
      return
    elseif key == keys.q then
      os.shutdown()
    end
  end
end
