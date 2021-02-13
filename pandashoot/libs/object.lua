cw = love.graphics.getWidth()
ch = love.graphics.getHeight()

object = {}

  object["panda"] = {
    filename = "panda",
    button = {left = "h", right = "l"},
    update = function(self, delta)
      if (love.keyboard.isDown(self.button.left)) then
        self.x = self.x - self.speed * delta
      elseif (love.keyboard.isDown(self.button.right)) then
        self.x = self.x + self.speed * delta
      end

      if (self.x < 0) then
        self.x = 0
      elseif (self.x > (cw - self.width)) then
        self.x = cw - self.width
      end
    end,
    rotation = 0,
    xscale = 1,
    yscale = 1,
    width = 0,
    height = 0,
    speed = 150,
    x = cw/2,
    y = 50
  }

  object["viper"] = {
    filename = "viper",
    update = function(self, delta)
      if (self.isRight) and (self.x < (cw - self.width)) then
        self.x = self.x + self.speed * delta
      else
        self.isRight = nil
        self.isLeft = true
      end

      if (self.isLeft) and (self.x > (0 + self.width)) then
        self.x = self.x - self.speed * delta
      else
        self.isLeft = nil
        self.isRight = true
      end
    end,
    rotation = 0,
    xscale = 0.7,
    yscale = 0.7,
    isRight = true,
    isLeft = nil,
    speed = 120,
    x = 300,
    y = ch - 100
  }

  object["bullet.logo"] = {
    filename = "bullet",
    rotation = 0,
    xscale = 0.7,
    yscale = 0.7,
    x = cw - 60,
    y = 20
  }

  object["bullet.number"] = {
    text = 10,
    rotation = 0,
    x = cw - 40,
    y = 20,
    xscale = 2,
    yscale = 2
  }

  object["points"] = {
    text = 0,
    rotation = 0,
    update = function(self, delta)
      self.x = panda.x - 30
      self.y = panda.y
    end,
    x = 0,
    y = 0,
    xscale = 2,
    yscale = 2
  }

function object.call(filename)
  return object[filename]
end

return object
