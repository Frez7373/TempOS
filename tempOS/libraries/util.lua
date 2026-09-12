local U = {}
function U.load(path)
  if not fs.exists(path) then return nil, "missing: "..path end
  local ok, v = pcall(dofile, path)
  if not ok then return nil, tostring(v) end
  return v
end
function U.safe(fn, ...)
  local ok, a,b,c,d = pcall(fn, ...)
  if not ok then return nil, tostring(a) end
  return a,b,c,d
end
function U.clamp(v,a,b) if v<a then return a elseif v>b then return b else return v end end
function U.trim(s) return (tostring(s):gsub("^%s+",""):gsub("%s+$","")) end
function U.readAll(path)
  local f=fs.open(path,"r"); if not f then return nil end; local s=f.readAll(); f.close(); return s
end
function U.write(path,s)
  fs.makeDir(fs.getDir(path)); local f=fs.open(path,"w"); if not f then return false end; f.write(s or ""); f.close(); return true
end
function U.timeString()
  local ok,t=pcall(os.time); if ok then return textutils.formatTime(t,true) end; return "--:--"
end
function U.dateString()
  local ok,d=pcall(os.day); if ok then return "Day "..tostring(d) end; return "Day ?" end
return U
