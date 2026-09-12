local M={
  bg=colors.black,
  panel=colors.gray,
  card=colors.lightGray,
  fg=colors.white,
  muted=colors.lightGray,
  accent=colors.blue,
  accent2=colors.cyan,
  danger=colors.red,
  success=colors.lime
}

local function color(value, fallback)
  if type(value)=="number" then return value end
  if type(fallback)=="number" then return fallback end
  return colors.white
end

function M.apply(t)
  for k,v in pairs(t or {}) do
    if M[k]~=nil and type(v)=="number" then M[k]=v end
  end
end

function M.fill(x1,y1,x2,y2,c)
  term.setBackgroundColor(color(c,M.bg))
  for y=y1,y2 do
    term.setCursorPos(x1,y)
    term.write(string.rep(" ",math.max(0,x2-x1+1)))
  end
end

function M.text(x,y,s,c)
  term.setTextColor(color(c,M.fg))
  term.setCursorPos(x,y)
  term.write(tostring(s or ""))
end

return M
