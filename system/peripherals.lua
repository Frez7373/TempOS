local M={devices={},lastScan=0}
function M.scan()
  M.devices={}
  for _,side in ipairs(peripheral.getNames()) do
    local ok,name=pcall(peripheral.getType,side)
    local typ=ok and name or "unknown"
    table.insert(M.devices,{side=side,type=typ,online=true,name=peripheral.getName(side) or typ})
  end
  M.lastScan=os.clock(); return M.devices
end
function M.byType(typ) local out={}; for _,d in ipairs(M.devices) do if d.type==typ then table.insert(out,d) end end; return out end
function M.find(typ) for _,d in ipairs(M.devices) do if d.type==typ then return d end end end
function M.test(d)
  if not d or not peripheral.isPresent(d.side) then return false,"offline" end
  local p=peripheral.wrap(d.side)
  if d.type=="speaker" then return p.playNote("pling") end
  if d.type=="printer" then return p.newPage() and p.endPage() end
  if d.type=="monitor" then p.setTextScale(1); p.clear(); p.setCursorPos(2,2); p.write("TempOS monitor test"); return true end
  if d.type=="modem" then return true end
  if d.type=="drive" then return p.isDiskPresent() end
  return true
end
return M
