local ui=dofile("/tempOS/ui/ui.lua")
local theme=dofile("/tempOS/ui/theme.lua")
local apps=dofile("/tempOS/system/apps.lua")
local log=dofile("/tempOS/libraries/log.lua")
local settings=dofile("/tempOS/system/settings.lua")
local D={}
local function chooseTerm()
  local names=peripheral.getNames()
  for _,p in ipairs(names) do
    if peripheral.getType(p)=="monitor" then
      local m=peripheral.wrap(p); if m then pcall(m.setTextScale,0.5); return m end
    end
  end
  return term.native and term.native() or term.current()
end
local function runApp(item)
  local ok,err=apps.run(item)
  if not ok then log.error(item.name..": "..tostring(err)); ui.message("Application crashed",item.name.." failed safely.\n\n"..tostring(err).."\n\nPress any key to return.") end
end
local function draw()
  ui.clear(); ui.header("Desktop")
  local w,h=term.getSize(); local list=apps.list(); local cols=w>=50 and 3 or 2; local bw=math.max(10,math.floor((w-2-(cols-1)*2)/cols)); local by=3
  for i,item in ipairs(list) do
    local row=math.floor((i-1)/cols); local col=(i-1)%cols; local x=2+col*(bw+2); local y=by+row*3
    if y<h-3 then ui.button(x,y,bw,item.icon.." "..item.name,false) end
  end
  ui.footer("Touch/click an app  |  R reboot  |  Q shutdown")
end
function D.run()
  local old=term.current(); local target=chooseTerm(); if target~=old then term.redirect(target) end
  while true do
    draw()
    local e,a,b,c=os.pullEvent()
    if e=="key" then
      if a==keys.q then break elseif a==keys.r then os.reboot() end
    elseif e=="monitor_touch" then
      local tx,ty=b,c; local w,h=term.getSize(); local list=apps.list(); local cols=w>=50 and 3 or 2; local bw=math.max(10,math.floor((w-2-(cols-1)*2)/cols)); local by=3
      for i,item in ipairs(list) do local row=math.floor((i-1)/cols); local col=(i-1)%cols; local x=2+col*(bw+2); local y=by+row*3; if ui.hit(x,y,bw,1,tx,ty) then runApp(item); break end end
    elseif e=="mouse_click" then
      local tx,ty=b,c; local w,h=term.getSize(); local list=apps.list(); local cols=w>=50 and 3 or 2; local bw=math.max(10,math.floor((w-2-(cols-1)*2)/cols)); local by=3
      for i,item in ipairs(list) do local row=math.floor((i-1)/cols); local col=(i-1)%cols; local x=2+col*(bw+2); local y=by+row*3; if ui.hit(x,y,bw,1,tx,ty) then runApp(item); break end end
    end
  end
  if target~=old then term.redirect(old) end
  term.setBackgroundColor(colors.black); term.setTextColor(colors.white); term.clear(); term.setCursorPos(1,1)
end
return D
