local N={}
function N.listModems()
  local out={}
  for _,p in ipairs(peripheral.getNames()) do local t=peripheral.getType(p); if t=="modem" or t=="wired_modem" or t=="wireless_modem" then table.insert(out,p) end end
  return out
end
function N.open()
  if not rednet then return false,"rednet unavailable" end
  local mods=N.listModems(); if #mods==0 then return false,"No modem" end
  for _,m in ipairs(mods) do pcall(rednet.open,m) end
  return true
end
function N.isOpen()
  if not rednet then return false end
  for _,m in ipairs(N.listModems()) do if rednet.isOpen(m) then return true end end
  return false
end
function N.broadcast(msg,protocol)
  if not N.isOpen() then local ok,err=N.open(); if not ok then return false,err end end
  return pcall(rednet.broadcast,msg,protocol)
end
function N.ping(id,timeout)
  if not N.isOpen() then N.open() end
  if not rednet then return false end
  local s=rednet.send(id,"TEMPOS_PING","tempos")
  return s
end
function N.info()
  return {open=N.isOpen(),modems=N.listModems(),computerId=os.getComputerID(),label=os.getComputerLabel() or ""}
end
return N
