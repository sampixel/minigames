function love.load()
  class = require("libs.class")

  cw = love.graphics.getWidth()
  ch = love.graphics.getHeight()

  game = {}
  game.begin = false

  stars = {}
  for i = 1, 50 do
    table.insert(stars, {
      x = love.math.random(tonumber(cw)),
      y = love.math.random(tonumber(ch)),
      width = 1, height = 1,
      speed = {
        x = love.math.random(20, 20),
        y = love.math.random(-30, 30)
      },
      update = function(self, delta)
        self.x = self.x + (self.speed.x * delta)
        self.y = self.y + (self.speed.y * delta)
        if (self.x + self.width > cw) then
          self.x = 0 - self.width
          self.y = love.math.random(tonumber(ch))
        elseif (self.y + self.height < 0) then
          self.x = love.math.random(tonumber(cw))
          self.y = ch + self.height
        end
      end
    })
  end

  rect = {
    red = {
      mode = "fill",
      x = 0, y = 0,
      width = cw,
      height = 20
    },
    blue = {
      mode = "fill",
      x = 0, y = ch - 20,
      width = cw,
      height = 20
    }
  }

  line = {
    red = {
      x1 = cw / 2, y1 = 0,
      x2 = cw / 2, y2 = ch / 2
    },
    blue = {
      x1 = cw / 2, y1 = ch / 2,
      x2 = cw / 2, y2 = ch
    }
  }

  asteroids = {}
  for i = 1, 20 do
    table.insert(asteroids, {
      image = love.graphics.newImage("images/asteroid.png"),
      x = love.math.random(50), y = love.math.random(100, ch - 100),
      speed = {x = love.math.random(100, 200)},
      update = function(self, delta)
        self.x = self.x + (self.speed.x * delta)
        if (self.x < 0 or self.x + self.width > cw) then
          self.speed.x = -self.speed.x
        end
      end
    })

    local asteroid = asteroids[#asteroids]
    local scale_factor = "0." .. tostring(love.math.random(2, 6))
    asteroid.width = asteroid.image:getWidth() * scale_factor
    asteroid.height = asteroid.image:getHeight() * scale_factor
    asteroid.scale = {x = scale_factor, y = scale_factor}
  end

  red_player = class:extend({
    filename = "red_player",
    text = {x = cw / 2 - 30, y = 30, rotation = 180, score = 0},
    x = (cw / 3) + 50, y = 18,
    scale = {x = 0.5, y = 0.5},
    speed = {y = 100},
    score = {num = 0, x = 50, y = 50},
    arrow = {
      image = love.graphics.newImage("images/arrow.png"),
      up = {
        x = cw / 2 - 150, y = 80,
        scale = {x = 0.5, y = 0.5}
      },
      down = {
        x = cw / 2 - 150, y = 60,
        scale = {x = 0.5, y = -0.5}
      }
    },
    update = function(self, delta)
      if (love.keyboard.isDown("w")) then
        self.y = self.y + (self.speed.y * delta)
      elseif (love.keyboard.isDown("s")) then
        self.y = self.y - (self.speed.y * delta)
      end

      if (self.y < 0) then
        self.y = 0
      elseif (self.y > ch) then
        self.y = 0
        self.text.score = self.text.score + 1
      end
    end
  })

  blue_player = class:extend({
    filename = "blue_player",
    text = {x = cw / 2 + 20, y = ch - 70, rotation = 0, score = 0},
    x = cw - ((cw / 3) + 50), y = ch - 50,
    scale = {x = 0.5, y = 0.5},
    speed = {y = 100},
    score = {num = 0, x = 50, y = 50},
    arrow = {
      image = love.graphics.newImage("images/arrow.png"),
      up = {
        x = cw / 2 + 150, y = ch - 80;
        scale = {x = 0.5, y = -0.5}
      },
      down = {
        x = cw / 2 + 150, y = ch - 60,
        scale = {x = 0.5, y = 0.5}
      }
    },
    update = function(self, delta)
      if (love.keyboard.isDown("k")) then
        self.y = self.y - (self.speed.y * delta)
      elseif (love.keyboard.isDown("j")) then
        self.y = self.y + (self.speed.y * delta)
      end

      if (self.y + self.height > ch) then
        self.y = ch - self.height
      elseif (self.y + self.height < 0) then
        self.y = ch - 50
        self.text.score = self.text.score + 1
      end
    end
  })

  red_player:load()
  blue_player:load()
end

function love.update(delta)
  if (game.begin) then
    for i = 1, #stars do
      stars[i]:update(delta)
    end

    for i = 1, #asteroids do
      asteroids[i]:update(delta)

      if (red_player:collision(asteroids[i])) then
        red_player.x = (cw / 3) + 50
        red_player.y = 18
      elseif (blue_player:collision(asteroids[i])) then
        blue_player.x = cw - ((cw / 3) + 50)
        blue_player.y = ch - 50
      end
    end

    red_player:update(delta)
    blue_player:update(delta)
  end
end

function love.draw()
  for i = 1, #stars do
    love.graphics.rectangle("fill", stars[i].x, stars[i].y, stars[i].width, stars[i].height)
  end

  for i = 1, #asteroids do
    love.graphics.draw(
      asteroids[i].image, asteroids[i].x, asteroids[i].y,
      asteroids[i].rotation, tonumber(asteroids[i].scale.x), tonumber(asteroids[i].scale.y)
    )
  end

  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.rectangle(rect.red.mode, rect.red.x, rect.red.y, rect.red.width, rect.red.height)
  love.graphics.line(line.red.x1, line.red.y1, line.red.x2, line.red.y2)
  red_player:print()

  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.rectangle(rect.blue.mode, rect.blue.x, rect.blue.y, rect.blue.width, rect.blue.height)
  love.graphics.line(line.blue.x1, line.blue.y1, line.blue.x2, line.blue.y2)
  blue_player:print()

  love.graphics.setColor(1, 1, 1, 1)
  red_player:draw()
  blue_player:draw()

  if (not game.begin) then
    love.graphics.print("\tTouch, Click here\n\tor press \"Enter\"\n\ton the keyboard", cw / 2 - 200, ch / 2 - 70, 0, 3, 3)
  end
end

function love.touchpressed()

end

function love.keypressed(key)
  if (key == "return") then
    game.begin = true
  elseif (key == "q") then
    love.event.quit("restart")
  end
end
