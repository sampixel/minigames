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
  self.xs = self.xs or 1
  self.ys = self.ys or 1

  love.graphics.draw(self.image, self.x, self.y, self.rotation, self.xs, self.ys)
end

function love.print(self)
  self.rotation = self.rotation or 0
  self.xs = self.xs or 1
  self.ys = self.ys or 1

  love.graphics.print(self.text, self.x, self.y, self.rotation, self.xs, self.ys)
end

return class
