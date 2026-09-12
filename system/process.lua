local M={nextPid=1,items={}}
function M.start(name)
  local p={pid=M.nextPid,name=name,status="RUNNING",started=os.epoch("utc"),memory=0}
  M.nextPid=M.nextPid+1; M.items[p.pid]=p; M.current=p.pid; return p
end
function M.finish(pid,status)
  local p=M.items[pid]; if p then p.status=status or "STOPPED"; p.finished=os.epoch("utc") end
end
function M.stop(pid) return M.finish(pid,"STOPPED") end
function M.list() local a={}; for _,p in pairs(M.items) do table.insert(a,p) end; table.sort(a,function(x,y)return x.pid<y.pid end); return a end
return M
