function love.load()
  class = require("libs.class")
  sound = require("libs.sound")

  sound.background:setLooping(true)
  sound.background:play()

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
  for i = 1, 50 do
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

  smoke = {}
  smoke.frames = {}
  smoke.image = love.graphics.newImage("images/smoke-sheet.png")
  smoke.width = smoke.image:getWidth()
  smoke.height = smoke.image:getHeight()
  smoke.scale = {x = 0.4, y = 0.4}
  smoke.num_frame_per_width = 10
  smoke.num_frame_per_height = 1
  smoke.frame_width = smoke.width * smoke.scale.x / smoke.num_frame_per_width
  smoke.frame_height = smoke.height * smoke.scale.y / smoke.num_frame_per_height
  smoke.current_frame = 1
  smoke.active = false

  for i = 0, smoke.num_frame_per_width - 1 do
    local size = 128
    table.insert(smoke.frames, love.graphics.newQuad(
      i * size, 0, size, size,
      smoke.width, smoke.height
    ))
  end

  collision = {}
  collision.frames = {}
  collision.image = love.graphics.newImage("images/collision-sheet.png")
  collision.width = collision.image:getWidth()
  collision.height = collision.image:getHeight()
  collision.scale = {x = 1, y = 1}
  collision.num_frame_per_width = 5
  collision.num_frame_per_height = 5
  collision.frame_width = collision.width * collision.scale.x / collision.num_frame_per_width
  collision.frame_height = collision.height * collision.scale.y / collision.num_frame_per_height
  collision.current_frame = 1
  collision.active = false

  for i = 0, collision.num_frame_per_height - 1 do
    local size = 320 / 5
    for j = 0, collision.num_frame_per_width - 1 do
      table.insert(collision.frames, love.graphics.newQuad(
        j * size, i * size, size, size,
        collision.width, collision.height
      ))
    end
  end

  time = {
    circle = {
      x = cw / 2.1,
      y = ch / 2.1,
      radius = 20
    },
    text = 60,
    scale = {x = 2, y = 2},
    update = function(self, delta)
      self.text = (tonumber(self.text) <= 0 and 0 or self.text - (delta / 1.1))
    end,
    draw = function(self)
      love.graphics.print(math.floor(self.text), self.circle.x, self.circle.y, 0, self.scale.x, self.scale.y)
    end
  }

  red_player = class:extend({
    filename = "red_player",
    text = {
      x = cw / 2 - 30,
      y = 80,
      score = 0,
      scale = {x = 2.5, y = -2.5}
    },
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
        sound.reward:play()
        self.text.score = self.text.score + 1
      end
    end
  })

  blue_player = class:extend({
    filename = "blue_player",
    text = {
      x = cw / 2 + 20,
      y = ch - 70,
      score = 0,
      scale = {x = 2.5, y = 2.5}
    },
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
      local mx, my = love.mouse.getPosition()
      if (mx > self.arrow.up.x and mx < self.arrow.image:getWidth() * self.arrow.up.scale.x and
          my > self.arrow.up.y and my < self.arrow.image:getHeight() * self.arrow.up.scale.y and love.mouse.isDown(1)) then
        print("iii")
        self.y = self.y + (self.speed.y * delta)
      elseif (mx > self.arrow.down.x and mx < self.arrow.image:getWidth() * self.arrow.down.scale.x and
          my > self.arrow.up.y and my < self.arrow.image:getHeight() * self.arrow.down.scale.y and love.mouse.isDown(1)) then
        self.y = self.y - (self.speed.y * delta)
      end

      if (love.keyboard.isDown("k")) then
        self.y = self.y - (self.speed.y * delta)
      elseif (love.keyboard.isDown("j")) then
        self.y = self.y + (self.speed.y * delta)
      end

      if (self.y + self.height > ch) then
        self.y = ch - self.height
      elseif (self.y + self.height < 0) then
        self.y = ch - 50
        sound.reward:play()
        self.text.score = self.text.score + 1
      end
    end
  })

  red_player:load()
  blue_player:load()
end

function love.update(delta)
  if (game.begin) then
    if (collision.current_frame >= collision.num_frame_per_width * collision.num_frame_per_height) then
      collision.active = false
      collision.current_frame = 1
    elseif (collision.active) then
      collision.current_frame = collision.current_frame + (delta * 40)
    end

    if (smoke.current_frame >= smoke.num_frame_per_width * smoke.num_frame_per_height) then
      smoke.active = false
      smoke.current_frame = 1
    elseif (smoke.active) then
      smoke.current_frame = smoke.current_frame + (delta * 20)
    end

    time:update(delta)

    for i = 1, #stars do
      stars[i]:update(delta)
    end

    for i = 1, #asteroids do
      asteroids[i]:update(delta)

      if (red_player:collision(asteroids[i])) then
        sound.impact:play()
        collision.x = asteroids[i].x + (asteroids[i].width * 2)
        collision.y = asteroids[i].y + (asteroids[i].height * 2)
        collision.active =  true
        red_player.x = (cw / 3) + 50
        red_player.y = 18
      elseif (blue_player:collision(asteroids[i])) then
        sound.impact:play()
        collision.x = asteroids[i].x + (asteroids[i].width * 2)
        collision.y = asteroids[i].y + (asteroids[i].height * 2)
        collision.active = true
        blue_player.x = cw - ((cw / 3) + 50)
        blue_player.y = ch - 50
      end
    end

    red_player:update(delta)
    blue_player:update(delta)
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)

  for i = 1, #stars do
    love.graphics.rectangle("fill", stars[i].x, stars[i].y, stars[i].width, stars[i].height)
  end

  for i = 1, #asteroids do
    love.graphics.draw(
      asteroids[i].image, asteroids[i].x, asteroids[i].y,
      asteroids[i].rotation, tonumber(asteroids[i].scale.x), tonumber(asteroids[i].scale.y)
    )
  end

  if (smoke.active) then
    love.graphics.draw(
      smoke.image, smoke.frames[math.floor(smoke.current_frame)],
      smoke.x, smoke.y, 0, smoke.scale.x, smoke.scale.y,
      smoke.frame_width, smoke.frame_height
    )
  end

  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.rectangle(rect.red.mode, rect.red.x, rect.red.y, rect.red.width, rect.red.height)
  love.graphics.line(line.red.x1, line.red.y1, line.red.x2, line.red.y2)
  red_player:print()
  red_player:draw_arrows()

  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.rectangle(rect.blue.mode, rect.blue.x, rect.blue.y, rect.blue.width, rect.blue.height)
  love.graphics.line(line.blue.x1, line.blue.y1, line.blue.x2, line.blue.y2)
  blue_player:print()
  blue_player:draw_arrows()

  love.graphics.setColor(1, 1, 1, 1)
  red_player:draw()
  blue_player:draw()

  if (collision.active) then
    love.graphics.draw(
      collision.image, collision.frames[math.floor(collision.current_frame)],
      collision.x, collision.y, 0, collision.scale.x, collision.scale.y,
      collision.frame_width, collision.frame_height
    )
  end

  if (not game.begin) then
    love.graphics.print("\tTouch, Click here\n\tor press \"Enter\"\n\ton the keyboard", cw / 2 - 200, ch / 2 - 70, 0, 3, 3)
  else
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", time.circle.x + 15, time.circle.y + 15, time.circle.radius)
    love.graphics.setColor(0, 0, 0, 1)
    time:draw()
  end
end

function love.touchpressed()

end

function love.mousepressed(x, y, button, istouch)
  if (button == 1) then
    if (x == red_player.arrow.up.x and y == red_player.arrow.up.y) then
      --red_player.y = red_player.y + (red_player.speed.y *
    end
  end
end

function love.keypressed(key)
  if (key == "return") then
    game.begin = true
  elseif (game.begin and key == "w") then
    sound.engine:play()
    smoke.active = true
    smoke.x = red_player.x + (red_player.width / 3)
    smoke.y = red_player.y - (red_player.height / 2)
  elseif (game.begin and key == "k") then
    sound.engine:play()
    smoke.active = true
    smoke.x = blue_player.x + (blue_player.width / 3)
    smoke.y = blue_player.y + blue_player.height + (blue_player.height / 2)
  elseif (key == "q") then
    love.event.quit("restart")
  end
end
