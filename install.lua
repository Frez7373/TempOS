local BASE="https://raw.githubusercontent.com/Frez7373/TempOS/main/"
local manifestURL=BASE.."manifest.lua"
term.setBackgroundColor(colors.black)
term.setTextColor(colors.cyan)
term.clear(); term.setCursorPos(1,1)
print("TempOS Installer 1.0.0")
print("Downloading release manifest...")
if not http or not http.get then error("HTTP API is disabled. Enable HTTP in CC:Tweaked settings.") end
local r=http.get(manifestURL)
if not r then error("Unable to reach GitHub. Check HTTP/network settings.") end
local src=r.readAll(); r.close()
local chunk=assert(load(src,"manifest","t",{}))
local m=chunk()
if type(m)~="table" or type(m.files)~="table" then error("Invalid manifest") end

local function ensureDir(path)
  local dir=fs.getDir(path)
  if dir~="" and not fs.exists(dir) then fs.makeDir(dir) end
end

fs.makeDir("/tempOS")
fs.makeDir("/tempOS/config")
fs.makeDir("/tempOS/data")
fs.makeDir("/tempOS/logs")
fs.makeDir("/tempOS/backups")

for i,path in ipairs(m.files) do
  write(string.format("[%02d/%02d] %s ",i,#m.files,path))
  local res=http.get(BASE..path)
  if not res then print("FAIL"); error("Download failed: "..path) end
  local data=res.readAll(); res.close()
  ensureDir(path)
  local f=assert(fs.open(path,"w")); f.write(data); f.close()
  term.setTextColor(colors.lime); print("OK"); term.setTextColor(colors.white)
end

local marker=fs.open("/tempOS/install.version","w")
marker.write("1.0.0"); marker.close()
print("")
term.setTextColor(colors.lime)
print("Installation complete!")
term.setTextColor(colors.white)
print("TempOS is ready.")
print("Reboot now? [Y/N]")
while true do
  local e,k=os.pullEvent("key")
  if e=="key" and k==keys.y then os.reboot() end
  if e=="key" and k==keys.n then break end
end
