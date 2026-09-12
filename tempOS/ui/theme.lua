local T={}
T.bg=colors.black; T.panel=colors.gray; T.panel2=colors.lightGray; T.text=colors.white; T.muted=colors.lightGray; T.accent=colors.cyan; T.good=colors.lime; T.bad=colors.red; T.warn=colors.yellow
function T.apply() term.setBackgroundColor(T.bg); term.setTextColor(T.text) end
return T
