local T=dofile("/ui/theme.lua")
term.clear(); term.setCursorPos(1,1); write("File to edit: "); local path=read(); if not path or path=="" then return end
local ok,err=pcall(function() shell.run("edit",path) end); if not ok then term.setTextColor(T.danger); print(err); os.pullEvent("key") end
