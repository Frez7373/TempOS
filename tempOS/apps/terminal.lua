local ui=dofile("/tempOS/ui/ui.lua")
local function run()
  local lines={"TempOS Terminal","Type help for commands."}
  local function draw()
    ui.clear(); ui.header("Terminal"); local _,h=term.getSize(); local start=math.max(1,#lines-h+4); for i=start,#lines do term.setCursorPos(2,3+i-start); print(lines[i]) end; ui.footer("Press Enter after typing a command; Q returns")
  end
  while true do
    draw(); local cmd=ui.input("Terminal","Command:",""); if cmd==nil or cmd=="q" then return end
    local p={}; for w in cmd:gmatch("%S+") do table.insert(p,w) end; local c=p[1] or ""
    if c=="" then table.insert(lines,">")
    elseif c=="help" then table.insert(lines,"help ls pwd cat mkdir label reboot shutdown clear")
    elseif c=="pwd" then table.insert(lines,"/")
    elseif c=="ls" then table.insert(lines,table.concat(fs.list("/"),"  "))
    elseif c=="cat" and p[2] then local f=fs.open(p[2],"r"); if f then table.insert(lines,f.readAll()); f.close() else table.insert(lines,"File not found") end
    elseif c=="mkdir" and p[2] then fs.makeDir(p[2]); table.insert(lines,"Created "..p[2])
    elseif c=="label" and p[2] then os.setComputerLabel(p[2]); table.insert(lines,"Label set")
    elseif c=="reboot" then os.reboot()
    elseif c=="shutdown" then os.shutdown()
    elseif c=="clear" then lines={"TempOS Terminal"}
    else table.insert(lines,"Unknown command: "..c) end
  end
end
run()
