local M={}
local modem
local function findModem(preferred)
  if preferred and peripheral.isPresent(preferred) and peripheral.getType(preferred)=="modem" then return peripheral.wrap(preferred),preferred end
  for _,s in ipairs(peripheral.getNames()) do if peripheral.getType(s)=="modem" then return peripheral.wrap(s),s end end
end
function M.init(side)
  modem, M.side = findModem(side)
  if modem and not modem.isOpen(42) then pcall(modem.open,42) end
  M.online=modem~=nil; M.sent=0; M.received=0
  return M.online
end
function M.send(id,msg,channel) if not modem then return false,"no modem" end; channel=channel or 42; modem.open(channel); modem.transmit(channel,channel,{kind="tempos",payload=msg,from=os.getComputerID()}); M.sent=M.sent+1; return true end
function M.broadcast(msg,channel) return M.send(nil,msg,channel) end
function M.ping(id,timeout)
  if not modem then return false end
  local ch=tonumber(1000+((os.getComputerID()*17)%900))
  modem.open(ch); modem.transmit(ch,ch,{kind="tempos_ping",from=os.getComputerID()})
  local timer=os.startTimer(timeout or 1)
  while true do local e,a,b,c,d=os.pullEvent(); if e=="modem_message" and c==ch and type(d)=="table" and d.kind=="tempos_pong" then modem.close(ch); return true,os.clock()-0 end; if e=="timer" and a==timer then modem.close(ch); return false end end
end
function M.handle(event,side,channel,reply,msg,distance)
  if type(msg)~="table" or msg.kind~="tempos" and msg.kind~="tempos_ping" then return nil end
  M.received=M.received+1
  if msg.kind=="tempos_ping" and modem then modem.transmit(channel,channel,{kind="tempos_pong",from=os.getComputerID()}) end
  return msg.payload,msg.from,distance
end
return M
