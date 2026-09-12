local ui=dofile("/tempOS/ui/ui.lua")
local function run()
  while true do
    ui.clear(); ui.header("Clock"); local w,h=term.getSize(); term.setCursorPos(math.max(1,math.floor(w/2)-4),math.floor(h/2)); term.setTextColor(colors.cyan); print(textutils.formatTime(os.time(),true)); term.setTextColor(colors.white); term.setCursorPos(math.max(1,math.floor(w/2)-6),math.floor(h/2)+2); print("Day "..os.day()); ui.footer("Q returns")
    local e,k=os.pullEvent("key"); if k==keys.q then return end
  end
end
run()
