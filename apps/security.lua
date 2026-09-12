local T=dofile("/ui/theme.lua")
local function scan(path)
  local files=fs.list(path); local checked=0; local threats={}
  for _,n in ipairs(files) do local p=fs.combine(path,n); if fs.isDir(p) then local a,b=scan(p); checked=checked+a; for _,v in ipairs(b) do table.insert(threats,v) end else checked=checked+1; if p:match("%.lua$") then local f=fs.open(p,"r"); local s=f and f.readAll() or ""; if f then f.close() end; if #s>250000 then table.insert(threats,p.." is unusually large") end; if s:match("os%.shutdown%s*%(%s*%)") and not s:match("TempOS") then table.insert(threats,p.." contains shutdown call") end end end end
  return checked,threats
end
while true do
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"TempOS Security",T.accent2); T.text(3,4,"Quick Scan",T.fg); T.text(3,6,"Full Scan",T.fg); T.text(3,8,"Password",T.fg); T.text(2,h,"[1] quick [2] full [3] password [ESC] exit",T.muted)
  local e,a=os.pullEvent(); if e=="key" and a==keys.esc then break end
  if e=="key" and a==keys.one then local n,t=scan("/apps"); term.clear(); T.text(2,2,"Quick Scan: "..n.." files",T.accent2); for i,v in ipairs(t) do T.text(2,2+i,"WARNING: "..v,T.danger) end; if #t==0 then T.text(2,4,"No heuristic findings.",T.success) end; os.pullEvent("key") end
  if e=="key" and a==keys.two then local n,t=scan("/"); term.clear(); T.text(2,2,"Full Scan: "..n.." files",T.accent2); for i,v in ipairs(t) do T.text(2,2+i,"WARNING: "..v,T.danger) end; if #t==0 then T.text(2,4,"No heuristic findings.",T.success) end; os.pullEvent("key") end
  if e=="key" and a==keys.three then term.clear(); T.text(2,2,"Password protection is managed by Recovery Mode.",T.muted); os.pullEvent("key") end
end
