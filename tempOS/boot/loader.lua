-- TempOS Bootloader
local ROOT = "/tempOS/"
local function paint(msg, ok)
  term.setTextColor(ok and colors.lime or colors.red)
  print((ok and "[ OK ] " or "[FAIL] ") .. msg)
  term.setTextColor(colors.white)
end
local function load(path)
  if not fs.exists(ROOT .. path) then return nil, "missing " .. path end
  local ok, value = pcall(dofile, ROOT .. path)
  if not ok then return nil, tostring(value) end
  return value
end
term.setBackgroundColor(colors.black); term.setTextColor(colors.white); term.clear(); term.setCursorPos(1,1)
print("TempOS")
print("Starting system...")
os.sleep(0.35)
local ok, kernel = load("kernel/kernel.lua")
if not kernel then
  term.setTextColor(colors.red); print("[FAIL] Loading kernel"); print(kernel or "unknown error")
  print(""); print("[R] Recovery  [S] Safe Mode  [Q] Shutdown")
  while true do
    local e,k = os.pullEvent("key")
    if k == keys.r or k == keys.s then
      local r = ROOT .. "recovery/recovery.lua"
      if fs.exists(r) then pcall(dofile, r) end
      return
    elseif k == keys.q then os.shutdown() end
  end
end

local stages = {
  "Initializing hardware",
  "Loading kernel",
  "Initializing memory manager",
  "Initializing network",
  "Initializing device manager",
  "Starting system services",
  "Starting graphical interface"
}
for _,s in ipairs(stages) do
  paint(s, true); os.sleep(0.12)
end
local okRun, err = pcall(kernel.run)
if not okRun then
  term.setBackgroundColor(colors.black); term.setTextColor(colors.red); term.clear(); term.setCursorPos(1,1)
  print("TempOS Kernel Error"); print(""); print(tostring(err)); print("")
  print("[R] Recovery   [Q] Shutdown")
  while true do
    local e,k = os.pullEvent("key")
    if k == keys.r then
      local r = ROOT .. "recovery/recovery.lua"; if fs.exists(r) then pcall(dofile,r) end; return
    elseif k == keys.q then os.shutdown() end
  end
end
