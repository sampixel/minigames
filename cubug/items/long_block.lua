local graphics = love.graphics
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local long_block = {
  image = graphics.newImage("images/long-block.png"),
  speed = 50,
  left = false,
  right = true,
  update = function(self, delta)
    self.body:setX(self.x)

    if (self.left) then
      self.x = self.x - (self.speed * delta)
    elseif (self.right) then
      self.x = self.x + (self.speed * delta)
    end

    if (self.body:enter("block")) then
      if (self.left) then
        self.left = false
        self.right = true
      elseif (self.right) then
        self.right = false
        self.left = true
      end
    end
  end,
  draw = function(self)
    graphics.draw(
      self.image, self.body:getX(), self.body:getY(),
      self.body:setAngle(0), 1, 1,
      self.width / 2, self.height / 2
    )
  end
}

function long_block.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

return long_block
