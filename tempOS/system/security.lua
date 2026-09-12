local S={}
local cfgPath="/tempOS/data/config.lua"
function S.loadConfig() local ok,c=pcall(dofile,cfgPath); if ok and type(c)=="table" then return c end; return {lockEnabled=false,password=""} end
function S.save(c)
  local f=fs.open(cfgPath,"w"); if not f then return false end
  f.write("return "..textutils.serialize(c)); f.close(); return true
end
function S.hash(s)
  -- Portable integrity fingerprint, not cryptographic authentication.
  local h=2166136261
  for i=1,#s do h=(h ~ string.byte(s,i)) * 16777619 % 4294967296 end
  return string.format("%08x",h)
end
function S.checkFile(path)
  if not fs.exists(path) then return false,"missing" end
  local f=fs.open(path,"r"); local d=f.readAll(); f.close()
  return true,S.hash(d),#d
end
function S.quickScan(root)
  local result={checked=0,suspicious={}}
  local function walk(p)
    if fs.isDir(p) then for _,n in ipairs(fs.list(p)) do walk(fs.combine(p,n)) end
    else
      result.checked=result.checked+1
      local low=p:lower()
      if low:find("autorun") and not low:find("/tempOS/") then table.insert(result.suspicious,p) end
    end
  end
  walk(root or "/"); return result
end
return S
