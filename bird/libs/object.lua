local graphics = love.graphics

local CW = love.graphics.getWidth()
local CH = love.graphics.getHeight()

local object = {
  bird = {
    filename = "bird-animation.png",
    x = CW / 3, y = CH / 4,
    scale = {x = 0.4, y = 0.4},
    speed = {y = 10},
    frame = {
      current = 1,
      num_width = 3,
      num_height = 2
    },
    update = function(self, delta)
      self.frame.current = self.frame.current + (delta * 30)
      self.y = self.y + (self.speed.y * delta)
      self.speed.y = self.speed.y + 20

      if (self.frame.current > (self.frame.num_width * self.frame.num_height)) then
        self.frame.current = 1
      end
    end,
    draw = function(self)
      graphics.draw(
        self.image, self.sheets[math.floor(self.frame.current)],
        self.x, self.y, 0, self.scale.x, self.scale.y
      )
    end,
    collision = function(self, target)
      if (self.x < target.x - (target.width / 2) + target.width and target.x - (target.width / 2) < self.x + self.frame.width and
          self.y < target.y - (target.height / 2) + target.height and target.y - (target.height / 2) < self.y + self.frame.height) then
        return true
      end
      return false
    end
  }
}

return object
