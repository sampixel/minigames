class = {}

function class.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function class.load(self)
  self.image = love.graphics.newImage("/images/" .. self.filename .. ".png")
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
  love.graphics.print(self.text, self.x, self.y, self.rotation, self.xscale, self.yscale)
end

function class.checkcollision(self, other)
  local self_left = self.x
  local self_right = self.x + self.width
  local self_top = self.y
  local self_bottom = self.y + self.height

  local other_left = other.x
  local other_right = other.x + other.width
  local other_top = other.y
  local other_bottom = other.y + other.height

  if ((self_right > other_left) and
      (self_left < other_right) and
      (self_bottom > other_top) and
      (self_top < other_top)) then
    return true
  end
end

return class
