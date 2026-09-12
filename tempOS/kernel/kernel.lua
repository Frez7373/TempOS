local K={}
local log=dofile("/tempOS/libraries/log.lua")
local settings=dofile("/tempOS/system/settings.lua")
local net=dofile("/tempOS/system/network.lua")
local devices=dofile("/tempOS/system/devices.lua")
K.version="1.0.0"; K.bootTime=os.clock(); K.running=true
function K.run()
  log.info("kernel start")
  local cfg=settings.get()
  if cfg.computerName and cfg.computerName~="" then pcall(os.setComputerLabel,cfg.computerName) end
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
