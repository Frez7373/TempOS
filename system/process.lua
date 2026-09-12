local M={nextPid=1,items={}}
function M.spawn(name,fn)
  local p={pid=M.nextPid,name=name,status="RUNNING",started=os.epoch("utc"),memory=0}
  M.nextPid=M.nextPid+1; M.items[p.pid]=p
  p.co=coroutine.create(function() local ok,err=xpcall(fn,debug.traceback); if not ok then p.status="CRASHED"; p.error=err end; if p.status=="RUNNING" then p.status="STOPPED" end end)
  return p
end
function M.tick()
  for _,p in pairs(M.items) do if p.status=="RUNNING" and coroutine.status(p.co)~="dead" then local ok=coroutine.resume(p.co); if not ok then p.status="CRASHED"; p.error="coroutine failure" end end end
end
function M.stop(pid) local p=M.items[pid]; if not p then return false end; p.status="STOPPED"; return true end
function M.list() local a={}; for _,p in pairs(M.items) do table.insert(a,p) end; table.sort(a,function(x,y)return x.pid<y.pid end); return a end
return M
