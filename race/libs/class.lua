local class = {}

local CH = love.graphics.getHeight()

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
  love.graphics.draw(self.image, self.x, self.y)
end

function class.update(self, dt)
  if (love.keyboard.isDown(self.upButton)) then
    self.y = self.y - self.speed * dt
  elseif (love.keyboard.isDown(self.downButton)) then
    self.y = self.y + self.speed * dt
  end

  if (self.y + self.height <= 0) then
    self.y = CH - self.height*2
    self.score = self.score + 1
  elseif (self.y + self.height >= CH) then
    self.y = CH - self.height
  end
end

function class.collision(self, obj)
  for i, _ in ipairs(obj) do
    if ((obj[i].x + obj[i].width > self.x) and (obj[i].y + obj[i].height > self.y) and
        (obj[i].x < self.x + self.width) and (obj[i].y < self.y + self.height)) then
      self.y = CH - self.height*1.5
    end
  end
end

return class
