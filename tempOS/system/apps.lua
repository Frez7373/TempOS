local A={}
A.dir="/tempOS/apps"
A.items={
 {name="Files",file="files.lua",icon="F"},{name="Settings",file="settings.lua",icon="S"},{name="Terminal",file="terminal.lua",icon=">"},{name="Editor",file="editor.lua",icon="E"},{name="Calculator",file="calculator.lua",icon="#"},{name="Clock",file="clock.lua",icon="C"},{name="Devices",file="devices.lua",icon="D"},{name="Network",file="network.lua",icon="N"},{name="Task Manager",file="taskmgr.lua",icon="T"},{name="Security",file="security.lua",icon="!"},{name="Update Manager",file="update.lua",icon="U"},{name="Package Manager",file="package.lua",icon="P"}
}
function A.list() return A.items end
function A.path(item) return A.dir.."/"..item.file end
function A.run(item,...)
  local p=A.path(item); if not fs.exists(p) then return false,"Application missing: "..p end
  local ok,err=pcall(dofile,p,...); if not ok then return false,tostring(err) end; return true
end
return A
