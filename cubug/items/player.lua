local graphics = love.graphics
local keyboard = love.keyboard
local random = love.math.random
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local player = {
  image = graphics.newImage("images/player.png"),
  speed = 100,
  cubes = {},
  update = function(self, delta)
    local _, vy = self.body:getLinearVelocity()
    if (vy > 2000) then
      love.event.quit("restart")
    end

    self.body:setX(self.x)
    if (keyboard.isDown("h")) then
      self.x = self.x - (self.speed * delta)
    elseif (keyboard.isDown("l")) then
      self.x = self.x + (self.speed * delta)
    end

    if (self.body:stay("long-block")) then
      local collision_data = self.body:getStayCollisionData("long-block")
      local long_block = collision_data.collider:getObject()
      
      if (self.body:getX() - (self.width / 2) < long_block.body:getX() - (long_block.width / 2)) then
        self.body:setX(long_block.body:getX() + (long_block.width / 2))
      elseif (self.body:getX() + (self.width / 2) > long_block.body:getX() + (long_block.width / 2)) then
        self.body:setX(long_block.body:getX() + (long_block.width / 2))
      end
    end
  end,
  draw = function(self)
    graphics.draw(
      self.image, self.body:getX(), self.body:getY(),
      self.body:setAngle(0), 1, 1, self.width / 2, self.height / 2
    )

    if (keyboard.isDown("h") or keyboard.isDown("l")) then
      local _, vy = self.body:getLinearVelocity()
      if not (vy > 0) then
        table.insert(self.cubes, {
          time = 0,
          radius = random(1, 2),
          x = (keyboard.isDown("h") and self.body:getX() + 10 or self.body:getX() - 10),
          y = self.body:getY() + 8,
          speed = {
            x = random(1) == 1 and random(-50, -10) or random(10, 50),
            y = random(1) == 1 and random(-50, -10) or random(10, 50)
          },
          update = function(self, delta)
            self.time = self.time + delta

            if (keyboard.isDown("h")) then
              self.x = self.x + (self.speed.x * delta)
            elseif (keyboard.isDown("l")) then
              self.x = self.x - (self.speed.x * delta)
            end

            self.y = self.y + (self.speed.y * delta)
          end
        })
      end
    end

    for i = 1, #self.cubes do
      if (self.cubes[i].time < 0.2) then
        graphics.circle("fill", self.cubes[i].x, self.cubes[i].y, self.cubes[i].radius)
      end
    end
  end,
  jump = function(self, value)
    local _, vy = self.body:getLinearVelocity()
    if not (vy < -1 or vy > 1) then
      self.body:applyForce(0, -value)
    end
  end
}

player.width = player.image:getWidth()
player.height = player.image:getHeight()
player.lifes = {}
for i = 1, 3 do
  table.insert(player.lifes, {
    image = graphics.newImage("images/block.png"),
    x = (cw - 100) + (32 * i),
    y = 20,
    speed = 10,
    time = 0,
    update = function(self, delta)
      self.y = self.y + (self.speed * delta)
      if (self.time > 2) then
        self.speed = -self.speed
        self.time = 0
      end
    end,
    draw = function(self)
      graphics.draw(self.image, self.x, self.y, 0, 2, 2)
    end
  })
end

return player
