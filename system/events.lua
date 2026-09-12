local M = {}
M.__index = M
function M.new() return setmetatable({handlers={}},M) end
function M:on(name,fn) self.handlers[name]=self.handlers[name] or {}; table.insert(self.handlers[name],fn); return fn end
function M:emit(name,...)
  local list=self.handlers[name] or {}
  for i=1,#list do pcall(list[i],...) end
end
function M:clear(name) self.handlers[name]=nil end
return M
