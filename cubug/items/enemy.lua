local graphics = love.graphics
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local enemy = {
  image = graphics.newImage("images/enemy.png"),
  speed = 50,
  left = true,
  right = false,
  update = function(self, delta)
    self.body:setX(self.x)

    if (self.left) then
      self.x = self.x - (self.speed * delta)
    elseif (self.right) then
      self.x = self.x + (self.speed * delta)
    end

    if (self.body:enter("block")) then
      local collision_data = self.body:getEnterCollisionData("block")
      local block = collision_data.collider:getObject()

      if (self.body:getY() == block.body:getY()) then
        self.left = not self.left
        self.right = not self.right
        print("self.left: " .. tostring(self.left))
        print("self.right: " .. tostring(self.right))
      end
    end
  end,
  draw = function(self)
    graphics.draw(
      self.image, self.body:getX(), self.body:getY(),
      self.body:setAngle(0), 1, 1,
      self.width / 2, self.height / 2
    )
  end,
  collision = function(self, object)
    if (self.body:getY() == object.body:getY() and self.body:getX() - (self.width / 2) < object.body:getX() + (object.width / 2)) then
      self.left = false
      self.right = true
    elseif (self.body:getY() == object.body:getY() and self.body:getX() + (self.width / 2) > object.body:getX() - (object.width / 2)) then
      self.right = false
      self.left = true
    end
  end
}

function enemy.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

return enemy
