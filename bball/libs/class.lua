local class = {}

function class.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function class.load(self)
  self.image = love.graphics.newImage("images/"  .. self.filename .. ".png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function class.draw(self)
  self.rotation = self.rotation or 0
  self.xscale = self.xscale or 1
  self.yscale = self.yscale or 1

  love.graphics.draw(self.image, self.x, self.y, self.rotation, self.xscale, self.yscale)
end

function class.print(self)
  self.rotation = self.rotation or 0
  self.xscale = self.xscale or 1
  self.yscale = self.yscale or 1

  love.graphics.print(self.text, self.x, self.y, self.rotation, self.xscale, self.yscale)
end

return class
