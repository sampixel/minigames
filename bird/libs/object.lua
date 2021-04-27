local cw = love.graphics.getWidth()
local ch = love.graphics.getHeight()

local object = {
  image = {
    filename = "background.png",
    scale = {x = 0.5, y = 0.4}
  },
  bird = {
    filename = "bird-animation.png",
    x = cw / 3, y = ch / 4,
    scale = {x = 0.4, y = 0.4},
    speed = {y = 10},
    frame = {
      current = 1,
      num_width = 6,
      num_height = 2
    },
    update = function(self, delta)
      self.frame.current = self.frame.current + (delta * 20)
      self.y = self.y + (self.speed.y * delta)
      self.speed.y = self.speed.y + 20

      if (self.frame.current > (self.frame.num_width * self.frame.num_height)) then
        self.frame.current = 1
      end
    end,
    draw = function(self)
      love.graphics.draw(
        self.image, self.sheets[math.floor(self.frame.current)],
        self.x, self.y, 0, self.scale.x, self.scale.y,
        self.frame.width, self.frame.height
      )
    end,
    collision = function(self, target)
      if (self.x < target.x + target.width and target.x < self.x + self.frame.width and
          self.y < target.y + target.height and target.y < self.y + self.frame.height) then
        return true
      end
      return false
    end
  },
  pipe = {
    filename = "pipe.png",
    speed = {x = 150},
    update = function(self, delta)
      self.x = self.x - (self.speed.x * delta)
    end,
    draw = function(self)
      love.graphics.draw(
        self.image, self.x, self.y, 0, self.scale.x, self.scale.y
        --self.width / 2, self.height / 2
      )
    end
  }
}

return object
