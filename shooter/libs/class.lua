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

  love.graphics.draw(self.image, self.x, self.y, self.rotation, self.xs, self.ys, self.width/2, 1)
end

function class.checkCollision(self, other)
  local s_left = self.x
  local s_top = self.y
  local s_bottom = self.y + self.height
  local s_right = self.x + self.width

  local o_left = other.x
  local o_top = other.y
  local o_bottom = other.y + other.height
  local o_right = other.x + other.width

  if (((o_bottom >= s_top) and (o_right >= s_left)) or
      ((o_bottom >= s_top) and (o_left <= s_right))) then
    return true
  end

  return false
end

return class
