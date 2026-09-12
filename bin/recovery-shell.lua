print("TempOS Recovery Shell")
while true do
 write("recovery$ "); local c=read(); if c=="exit" then break elseif c=="ls" then for _,n in ipairs(fs.list("/")) do print(n) end elseif c=="logs" then if fs.exists("/tempOS/logs") then for _,n in ipairs(fs.list("/tempOS/logs")) do print(n) end end elseif c=="reboot" then os.reboot() elseif c=="shutdown" then os.shutdown() elseif c=="repair" then fs.makeDir("/tempOS/config"); fs.makeDir("/tempOS/logs"); print("Repaired") else print("Commands: ls logs repair reboot shutdown exit") end
end
