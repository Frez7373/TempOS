local T=dofile("/ui/theme.lua")
while true do
  local w,h=term.getSize(); T.fill(1,1,w,h,T.bg); T.text(2,2,"Task Manager",T.accent2); T.text(2,3,"PID   NAME                 STATUS",T.muted)
  local tasks=TempOS.taskList(); for i,p in ipairs(tasks) do local s=string.format("%-5s %-20s %s",p.pid,p.name,p.status); T.text(2,i+4,s,T.fg) end
  T.text(2,h,"[ESC] Exit",T.muted)
  local e,a=os.pullEvent(); if e=="key" and a==keys.esc then break end
end
