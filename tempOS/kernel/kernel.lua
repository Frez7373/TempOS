local K={}
local log=dofile("/tempOS/libraries/log.lua")
local settings=dofile("/tempOS/system/settings.lua")
local security=dofile("/tempOS/system/security.lua")
local net=dofile("/tempOS/system/network.lua")
local devices=dofile("/tempOS/system/devices.lua")
local ui=dofile("/tempOS/ui/ui.lua")
K.version="1.0.0"; K.bootTime=os.clock(); K.running=true
function K.run()
  log.info("kernel start")
  local cfg=settings.get()
  if cfg.computerName and cfg.computerName~="" then pcall(os.setComputerLabel,cfg.computerName) end
  if cfg.lockEnabled and cfg.password and cfg.password~="" then
    local tries=0
    while tries<3 do
      local v=ui.input("TempOS Lock","Enter password:","")
      if v and (v==cfg.password or security.hash(v)==cfg.password) then break end
      tries=tries+1; ui.message("Access denied","Incorrect password. Attempt "..tries.." of 3.")
      if tries>=3 then os.shutdown() end
    end
  end
  pcall(net.open)
  local desktopPath="/tempOS/apps/desktop.lua"
  if not fs.exists(desktopPath) then error("desktop missing") end
  local ok,desktop=pcall(dofile,desktopPath)
  if not ok then log.error(desktop); error(desktop) end
  if type(desktop)=="table" and desktop.run then desktop.run(K) else error("invalid desktop") end
end
function K.info()
  local ok,free=pcall(function() return fs.getFreeSpace("/") end)
  return {version=K.version,id=os.getComputerID(),label=os.getComputerLabel() or "",free=ok and free or 0,devices=#devices.scan()}
end
return K
