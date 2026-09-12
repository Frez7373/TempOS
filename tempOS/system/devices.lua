local D={}
function D.scan()
  local out={}
  for _,p in ipairs(peripheral.getNames()) do
    local ok,typ=pcall(peripheral.getType,p)
    local methods={}
    if ok then for _,m in ipairs(peripheral.getMethods(p) or {}) do table.insert(methods,m) end end
    table.insert(out,{name=p,type=typ or "unknown",methods=methods})
  end
  return out
end
function D.call(name,method,...)
  if not peripheral.isPresent(name) then return false,"device removed" end
  local ok,a,b,c=pcall(peripheral.call,name,method,...)
  if not ok then return false,tostring(a) end
  return true,a,b,c
end
return D
