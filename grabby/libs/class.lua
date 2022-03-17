local class = {}

local cw = love.graphics.getWidth()
local ch = love.graphics.getHeight()

function class.extend(self, object) -- extend constructor
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function class.load(self) -- load object
  self.image = love.graphics.newImage("images/" .. self.filename)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function class.draw(self)
  love.graphics.draw(
    self.image, self.body:getX(), self.body:getY(),
    self.angle or 0, self.scale.x or 1, self.scale.y or 1,
    self.image:getWidth() / 2, self.image:getHeight() / 2
  )
end

function class.rescale(self)
  self.width = self.width * self.scale.x
  self.height = self.height * self.scale.y
end

--[[
function class.collision(self, object)  -- check for collision
  if ((self.x < object.x + object.width) and (object.x < self.x + self.width) and
      (self.y < object.y + object.height) and (object.y < self.y + self.height)) then
    return true
  end
  return false
end
--]]

return class
