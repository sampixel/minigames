local class = {}

function class.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function class.load(self)
  self.image = love.graphics.newImage("images/" .. self.filename)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function class.draw(self)
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale.x, self.scale.y)
end

function class.rescale(self)
  self.width = self.width * self.scale.x
  self.height = self.height * self.scale.y
end

return class
