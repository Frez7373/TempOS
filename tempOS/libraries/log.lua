local L = {}
local path = "/tempOS/data/system.log"
local function stamp() return "["..tostring(os.day()).." "..textutils.formatTime(os.time(),true).."] " end
function L.write(level,msg)
  fs.makeDir("/tempOS/data")
  local f=fs.open(path,"a"); if not f then return end
  f.writeLine(stamp().."["..tostring(level).."] "..tostring(msg)); f.close()
end
function L.info(m) L.write("INFO",m) end
function L.warn(m) L.write("WARN",m) end
function L.error(m) L.write("ERROR",m) end
function L.path() return path end
return L
