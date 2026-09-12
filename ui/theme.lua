local M={bg=colors.black,panel=colors.gray,card=colors.lightGray,text=colors.white,muted=colors.lightGray,accent=colors.blue,accent2=colors.cyan,danger=colors.red,success=colors.lime}
function M.apply(t) for k,v in pairs(t or {}) do if M[k]~=nil then M[k]=v end end end
function M.fill(x1,y1,x2,y2,c) term.setBackgroundColor(c or M.bg); for y=y1,y2 do term.setCursorPos(x1,y); term.write(string.rep(" ",x2-x1+1)) end end
function M.text(x,y,s,c) term.setTextColor(c or M.text); term.setCursorPos(x,y); term.write(s) end
return M
