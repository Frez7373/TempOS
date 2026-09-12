local S={}
local path="/tempOS/data/config.lua"
function S.get()
  local ok,c=pcall(dofile,path)
  if ok and type(c)=="table" then return c end
  return {version="1.0.0",name="TempOS",computerName="TempComputer",theme="default",lockEnabled=false,password="",updateURL="https://raw.githubusercontent.com/Frez7373/TempOS/main/"}
end
function S.save(c)
  local f=fs.open(path,"w")
  if not f then return false end
  f.write("return "..textutils.serialize(c)); f.close(); return true
end
function S.set(k,v) local c=S.get(); c[k]=v; return S.save(c) end
return S
