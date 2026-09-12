local VERSION="1.0.1"
local T=dofile("/ui/theme.lua")
local P=dofile("/system/peripherals.lua")
local N=dofile("/system/network.lua")
local Proc=dofile("/system/process.lua")
local Security=dofile("/system/security.lua")
local E=dofile("/system/events.lua").new()
local DATA="/tempOS/config/settings.tbl"
fs.makeDir("/tempOS/config"); fs.makeDir("/tempOS/logs")
local function loadSettings()
  if fs.exists(DATA) then local f=fs.open(DATA,"r"); local s=f.readAll(); f.close(); local ok,v=pcall(textutils.unserialise,s); if ok and type(v)=="table" then return v end end
  return {computerName="TempOS PC",accent="blue",sounds=true,lockMinutes=0}
end
_G.TempOS={version=VERSION,boot=os.epoch("utc"),settings=loadSettings(),events=E,process=Proc,network=N,devices=P,security=Security}
TempOS.log=function(kind,msg) local f=fs.open("/tempOS/logs/"..kind..".log","a"); if f then f.writeLine(os.date("!%Y-%m-%dT%H:%M:%SZ").." "..tostring(msg)); f.close() end end
TempOS.notify=function(msg,kind) TempOS.events:emit("notify",msg,kind or "info") end
TempOS.saveSettings=function() local f=fs.open(DATA,"w"); f.write(textutils.serialise(TempOS.settings)); f.close() end
local native=term.native()
local screen=native
local screenSide="term"
local monitor=nil
local function chooseScreen()
  for _,d in ipairs(P.scan()) do
    if d.type=="monitor" then
      local ok,m=pcall(peripheral.wrap,d.side)
      if ok and m then
        if m.setTextScale then pcall(m.setTextScale,1) end
        local okSize,mw,mh=pcall(m.getSize)
        if okSize and type(mw)=="number" and type(mh)=="number" then
          monitor=m
          return window.create(m,1,1,mw,mh,true),d.side
        end
      end
    end
  end
  return native,"term"
end
screen,screenSide=chooseScreen()
TempOS.screen=screen
TempOS.screenSide=screenSide
term.redirect(screen)
P.scan(); N.init()
if not Security.login() then term.clear(); term.setCursorPos(1,1); print("Invalid password."); print("Rebooting..."); sleep(2); os.reboot() end
local apps={
  settings={name="Settings",icon="S",path="/apps/settings.lua"},filemanager={name="Files",icon="F",path="/apps/filemanager.lua"},terminal={name="Terminal",icon=">_",path="/apps/terminal.lua"},calculator={name="Calculator",icon="=",path="/apps/calculator.lua"},clock={name="Clock",icon="O",path="/apps/clock.lua"},systeminfo={name="System Info",icon="i",path="/apps/systeminfo.lua"},taskmanager={name="Task Manager",icon="T",path="/apps/taskmanager.lua"},editor={name="Text Editor",icon="E",path="/apps/editor.lua"},security={name="Security",icon="S",path="/apps/security.lua"},devices={name="Devices",icon="D",path="/apps/devices.lua"},network={name="Network",icon="N",path="/apps/network.lua"},updater={name="Updater",icon="U",path="/apps/updater.lua"}}
TempOS.apps=apps
function TempOS.appLaunch(id)
  local a=apps[id]; if not a or not fs.exists(a.path) then return false,"application missing" end
  local p=Proc.start(a.name); local ok,err=xpcall(function() dofile(a.path) end,debug.traceback); Proc.finish(p.pid,ok and "STOPPED" or "CRASHED"); if not ok then TempOS.log("crash",id.."\n"..err); return false,err end; return true
end
function TempOS.shutdown(reboot)
  pcall(screen.clear)
  if monitor and monitor~=screen then pcall(monitor.clear) end
  term.redirect(native)
  if reboot then os.reboot() else os.shutdown() end
end
function TempOS.taskList() local out={{pid=0,name="Desktop",status="Running",memory=0}}; for _,p in ipairs(Proc.list()) do table.insert(out,p) end; return out end
local Desktop=dofile("/ui/desktop.lua"); local ok,err=xpcall(function() Desktop.run(TempOS) end,debug.traceback)
if not ok then TempOS.log("crash","desktop\n"..err); term.redirect(native); term.setBackgroundColor(colors.black); term.setTextColor(colors.red); term.clear(); term.setCursorPos(1,1); print("TempOS desktop crashed."); print(err); print(); print("Press Enter to reboot."); os.pullEvent("key"); os.reboot() end
TempOS.saveSettings()
