local object = {}

local CW = love.graphics.getWidth()
local CH = love.graphics.getHeight()

object["back"] = {
  filename = "background",
  x = - 5, y = - 300,
  speed = 8,
  width = CW,
  height = CH,
  xs = 1.8, ys = 1.8
}

object["cube"] = {
  filename = "vbox",
  speed = 100,
  toLeft = true,
  toRight = false,
  x = 20, y = 20,
  xs = 0.5, ys = 0.5,
  update = function(self, dt)
    if (self.toLeft) then
      self.x = self.x - self.speed * dt
    elseif (self.toRight) then
      self.x = self.x + self.speed * dt
    end

    if (self.x <= 0) and (self.toLeft) then
      self.toLeft = false
      self.toRight = true
    elseif ((self.x + self.width*2) >= CW) and (self.toRight) then
      self.toRight = false
      self.toLeft = true
    end
  end
}

object["gameover"] = {
  filename = "gameover",
  x = 30, y = 50,
  xs = 0.5, ys = 0.5
}

return object
