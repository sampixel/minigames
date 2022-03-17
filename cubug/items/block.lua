local graphics = love.graphics

local block = {
  image = graphics.newImage("images/block.png"),
  draw = function(self)
    graphics.draw(
      self.image, self.body:getX(), self.body:getY(),
      self.body:setAngle(0), 1, 1,
      self.width / 2, self.height / 2
    )
  end
}

function block.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

return block
