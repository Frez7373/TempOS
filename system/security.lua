local M={file="/tempOS/config/security.tbl"}
local function hash(s)
  local h=2166136261
  for i=1,#s do h=(h ~ s:byte(i))*16777619 % 4294967296 end
  return string.format("%08x",h)
end
function M.load()
  if not fs.exists(M.file) then return {enabled=false} end
  local f=fs.open(M.file,"r"); local s=f.readAll(); f.close(); local ok,v=pcall(textutils.unserialise,s); if ok and type(v)=="table" then return v end; return {enabled=false}
end
function M.save(v) local f=fs.open(M.file,"w"); f.write(textutils.serialise(v)); f.close() end
function M.setPassword(password) if type(password)~="string" or #password<4 then return false,"password must contain at least 4 characters" end; M.save({enabled=true,hash=hash(password)}); return true end
function M.clearPassword() M.save({enabled=false}); return true end
function M.verify(password) local v=M.load(); return v.enabled and hash(password)==v.hash or not v.enabled end
function M.login() local v=M.load(); if not v.enabled then return true end; term.clear(); term.setCursorPos(1,1); term.setTextColor(colors.cyan); print("TEMP OS"); term.setTextColor(colors.white); print(); write("Enter password: "); local p=read("*"); return M.verify(p) end
function M.audit(action) fs.makeDir("/tempOS/logs"); local f=fs.open("/tempOS/logs/security.log","a"); if f then f.writeLine(os.date("!%Y-%m-%dT%H:%M:%SZ").." "..action); f.close() end end
return M
