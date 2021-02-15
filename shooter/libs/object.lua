local object = {}

local CW = love.graphics.getWidth()
local CH = love.graphics.getHeight()

object["shooter"] = {
  filename = "shooter",
  status = "idle",
  lives = 3,
  speed = 300,
  xs = 1, ys = 1,
  frames = {},
  currentframe = 1,
  framewidth = 100,
  frameheight = 100,
  update = function(self, dt)
    if (love.keyboard.isDown("h")) then
      self.status = "walking"
      self.currentframe = 7
      self.x = self.x - self.speed * dt
      self.xs = -1
    elseif (love.keyboard.isDown("l")) then
      self.status = "walking"
      self.currentframe = 7
      self.x = self.x + self.speed * dt
      self.xs = 1
    end 

    if (self.x - (self.width/2) <= 0) then
      self.x = 0 + (self.width/2)
    elseif(self.x + (self.width/2) >= CW) then
      self.x = CW - (self.width/2)
    end

    if (self.status == "idle") and (self.currentframe >= 6) then
      self.currentframe = 1
    elseif (self.status == "walking") and (self.currentframe >= 12) then
      self.currentframe = 7
    end
    
    self.currentframe = self.currentframe + (5 * dt)
  end
}

--[[
object["enemy"] = {
  filename = "enemy",
  speed = 200,
  toRight = false,
  toLeft = true,
  x = CW / 2, y = 30,
  xs = 1, ys = 1,
  update = function(self, dt)
    if (self.toRight) then
      self.x = self.x - ((self.speed / 2) * dt)
    elseif (self.toLeft) then
      self.x = self.x + ((self.speed / 2) * dt)
    end

    self.y = self.y + self.speed * dt
  end,
  checkBoundCollision = function(self)
    if (self.y + self.height >= CH) then
      self:applyLinearImpulse(0, -100)
      self.toRight = false
      self.toLeft = true
    elseif (self.x <= 0) then
      self:applyLinearImpulse(50, 0)
      self.toLeft = false
      self.toRight = true
    elseif (self.x + self.width >= CW) then
      self:applyLinearImpulse(-50, 0)
    end
  end
}
--]]

return object
