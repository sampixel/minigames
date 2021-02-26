local class = {}

function class.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end


function class.direction(self, value)
  for k, v in pairs(self) do
    if (k == value) then
      print("k: " .. k, "v: " .. tostring(v), "self[k]: " .. tostring(self[k]), "value: " .. value)
      self[k] = true
    else
      self[k] = false
    end
  end
end


function class.update(self, dt)
  if (self.bottom) then
    self.y = self.y + self.height
  elseif (self.top) then
    self.y = self.y - self.height
  elseif (self.left) then
    self.x = self.x - self.width
  elseif (self.right) then
    self.x = self.x + self.width * dt
  end
end


return class
