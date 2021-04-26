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

  if (self.scale.x and self.scale.y) then
    self.width = self.width * self.scale.x
    self.height = self.height * self.scale.y
  end
end

function class.draw(self)
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale.x, self.scale.y)
end

function class.draw_arrows(self)
  love.graphics.draw(self.arrow.image, self.arrow.up.x, self.arrow.up.y, 0, self.arrow.up.scale.x, self.arrow.up.scale.y)
  love.graphics.draw(self.arrow.image, self.arrow.down.x, self.arrow.down.y, 0, self.arrow.down.scale.x, self.arrow.down.scale.y)
end

function class.print(self)
  love.graphics.print(self.text.score, self.text.x, self.text.y, 0, self.text.scale.x, self.text.scale.y)
end

function class.collision(self, target)
  if (self.x < target.x + target.width and target.x < self.x + self.width and
      self.y < target.y + target.height and target.y < self.y + self.height) then
    return true
  end
  return false
end

return class
