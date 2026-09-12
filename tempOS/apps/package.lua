local ui=dofile("/tempOS/ui/ui.lua")
local function run()
  while true do
    ui.clear(); ui.header("Package Manager"); print("Install a Lua application from an HTTPS/HTTP URL."); print("Installed files are placed in /tempOS/apps/user."); ui.button(2,7,22,"Install URL",false); ui.button(26,7,22,"Back",true); ui.footer("Touch/click or Q")
    local e,a,b,c=os.pullEvent(); if e=="key" and a==keys.q then return elseif e=="monitor_touch" or e=="mouse_click" then local x,y=b,c
      if ui.hit(2,7,22,1,x,y) then
        local url=ui.input("Install Application","URL:",""); if url and url~="" then
          if not http or not http.get then ui.message("Package Manager","HTTP is disabled.") else
            local h,err=http.get(url,nil,true); if not h then ui.message("Package Manager",tostring(err)) else local d=h.readAll(); h.close(); if not d or #d==0 then ui.message("Package Manager","Downloaded file is empty.") else fs.makeDir("/tempOS/apps/user"); local name=url:match("([^/]+)$") or "app.lua"; if not name:match("%.lua$") then name=name..".lua" end; local f=fs.open("/tempOS/apps/user/"..name,"w"); if f then f.write(d); f.close(); ui.message("Package Manager","Installed /tempOS/apps/user/"..name) else ui.message("Package Manager","Cannot write application.") end end end end
        end
      elseif ui.hit(26,7,22,1,x,y) then return end
    end
  end
end
run()
