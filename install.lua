local BASE="https://raw.githubusercontent.com/Frez7373/TempOS/main/"
local manifestURL=BASE.."manifest.lua"
term.setTextColor(colors.cyan); print("TempOS Installer 1.0.1"); print("Downloading release manifest...")
local r=http.get(manifestURL); if not r then error("Unable to reach GitHub. Check HTTP/network settings.") end
local src=r.readAll(); r.close(); local chunk=assert(load(src,"manifest","t",{})); local m=chunk(); if type(m)~="table" then error("Invalid manifest") end
fs.makeDir("/tempOS/logs"); fs.makeDir("/tempOS/config");
for i,path in ipairs(m.files) do
  io.write(string.format("[%02d/%02d] %s",i,#m.files,path))
  local res=http.get(BASE..path); if not res then print(" FAIL"); error("Download failed: "..path) end
  local data=res.readAll(); res.close(); fs.makeDir(fs.getDir(path)); local f=assert(fs.open(path,"w")); f.write(data); f.close(); print(" OK")
end
print(); print("Installation complete!"); print("TempOS is ready."); print("Reboot now? [Y/N]"); while true do local e,k=os.pullEvent("key"); if k==keys.y then os.reboot() elseif k==keys.n then break end end
