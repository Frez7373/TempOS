local ui=dofile("/tempOS/ui/ui.lua")
local function run()
  while true do
    ui.clear(); ui.header("Calculator"); term.setCursorPos(2,3); print("Enter arithmetic expression:"); term.setCursorPos(2,5); print("Examples: 12+7   5*8   100/4"); ui.footer("Q returns")
    local s=ui.input("Calculator","Expression:",""); if not s or s=="q" then return end
    local f=loadstring("return "..s); if not f then ui.message("Calculator","Invalid expression") else local ok,v=pcall(f); if ok then ui.message("Calculator","Result: "..tostring(v)) else ui.message("Calculator","Error: "..tostring(v)) end end
  end
end
run()
