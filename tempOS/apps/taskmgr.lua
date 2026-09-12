local ui=dofile("/tempOS/ui/ui.lua")
local function run()
  ui.clear(); ui.header("Task Manager"); print("PID  STATE       PROCESS"); print("1    RUNNING     TempOS Desktop"); print("2    SYSTEM      Kernel"); print("3    SYSTEM      Network Manager"); print(""); print("TempOS uses cooperative foreground applications to isolate crashes."); ui.footer("Press any key to return"); os.pullEvent("key")
end
run()
