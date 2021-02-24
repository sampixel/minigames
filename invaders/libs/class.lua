local class = {}

function class.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end


function class.load(self)
  self.image = love.graphics.newImage("images/" .. self.filename .. ".png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end


function class.draw(self)
  self.rotation = self.rotation or 0
  self.scaleX = self.scaleX or 1
  self.scaleY = self.scaleY or 1
  love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scaleX, self.scaleY)
end

function class.collision(self, object)
  if ((self.x < object.x + object.width) and (object.x < self.x + self.width) and
      (self.y < object.y + object.height) and (object.y < self.y + self.height)) then
    return true
  end
  return false
end

return class
