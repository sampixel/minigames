local graphics = love.graphics
local mouse = love.mouse

function love.load()
  class = require("libs.class")   -- require modules
  object = require("libs.object")
  sound = require("libs.sound")

  sound.music:setLooping(true)
  sound.music:play()

  CW = graphics.getWidth() -- coordinates window
  CH = graphics.getHeight()

  cursor = mouse.getSystemCursor("hand")
  mouse.setCursor(cursor)

  graphics.setNewFont("font/SuperMarioDsRegular-Ea4R8.ttf", 20)   -- set font

  point = 0 -- forward variables
  shake = 0
  time = 0
  gap = 2
  playing = true
  started = false
  ended = false

  back = {} -- background
  back.image = graphics.newImage("images/background.png")
  back.width = back.image:getWidth()
  back.height = back.image:getHeight()
  back.scale = {x = 0.5, y = 0.4}

  lifes = {}
  for i = 1, 3 do
    table.insert(lifes, class:extend({
      filename = "bird-animation.png",
      x = CW - (30 * i),
      y = 30,
      scale = {x = -0.2, y = 0.2},
      frame = {
        current = 1,
        num_width = 3,
        num_height = 2
      },
      update = function(self, delta)
        self.frame.current = self.frame.current + (delta * 10)
        if (self.frame.current > self.frame.num_width * self.frame.num_height) then
          self.frame.current = 1
        end
      end,
      draw = function(self)
        graphics.draw(
          self.image, self.sheets[math.floor(self.frame.current)],
          self.x, self.y, 0, self.scale.x, self.scale.y
        )
      end
    }))

    local life = lifes[#lifes]
    life:load()

    life.sheets = {}
    life:quad()
  end

  cover = {}  -- cover
  cover.image = graphics.newImage("images/cover.png")
  cover.width = cover.image:getWidth()
  cover.height = cover.image:getHeight()
  cover.scale = {x = 1.2, y = 1.2}
  cover.x = CW / 2
  cover.y = CH / 3

  text = {  -- option text
    play = {
      title = "PLAY",
      x = CW / 3.5,
      y = CH - (CH / 4),
      selected = true
    },
    audio = {
      title = "AUDIO",
      x = CW - (CW / 2.5),
      y = CH - (CH / 4),
      selected = false
    }
  }

  clouds = {}
  for i = 1, 5 do
    local cloud = {
      image = graphics.newImage("images/cloud.png"),
      x = math.random(CW),
      y = math.random(CH),
      speed = {x = math.random(50, 100)},
      scale = {
        x = "2." .. math.random(9),
        y = "2." .. math.random(9)
      }
    }
    cloud.width = cloud.image:getWidth() * cloud.scale.x
    cloud.height = cloud.image:getHeight() * cloud.scale.y
    cloud.update = function(self, delta)
      self.x = self.x - (self.speed.x * delta)
      if (self.x + self.width < 0) then
        self.x = CW
        self.y = math.random(CH)
        self.speed.x = math.random(50, 100)
      end
    end
    cloud.draw = function(self)
      graphics.draw(
        self.image, self.x, self.y, 0,
        (math.random(1) == 1 and self.scale.x or -self.scale.x),
        (math.random(1) == 0 and self.scale.y or -self.scale.y)
      )
      end
    table.insert(clouds, cloud)
  end

  bird = class:extend(object.bird)  -- bird
  bird:load()
  bird.frame.width = bird.width * bird.scale.x / bird.frame.num_width
  bird.frame.height = bird.height * bird.scale.y / bird.frame.num_height
  bird.sheets = {}
  bird:quad()

  pipes = {}  -- pipes
end 

function love.update(delta)
  for i = 1, #clouds do -- update clouds
    clouds[i]:update(delta)
  end

  if (started) then
    if (shake > 0) then
      shake = shake - delta
    end

    for i = 1, #lifes do
      lifes[i]:update(delta)
    end

    bird:update(delta)  -- update bird

    time = time + delta

    if (time > gap) then  -- create 3 pipes when time reaches limit
      table.insert(pipes, {})

      for i = 1, 3 do
        table.insert(pipes[#pipes], class:extend({
          filename = "pipe.png",
          speed = {x = 150},
          update = function(self, delta)
            self.x = self.x - (self.speed.x * delta)
          end,
          draw = function(self)
            graphics.draw(
              self.image, self.x, self.y, self.angle or 0,
              self.scale.x, self.scale.y,
              self.image:getWidth() / 2, self.image:getHeight() / 2
            )
        end
        }))
      end

      local top = pipes[#pipes][1]
      top:load()
      top.x = CW + 100
      top.y = 0
      top.angle = math.rad(math.deg(219.91/2))
      top.scale = {x = 0.7, y = tostring(math.random(1)) .. "." .. math.random(9)}
      top.height = top.image:getHeight() * top.scale.y
      top.width = top.image:getWidth() * top.scale.x
      top.visible = true

      local bot = pipes[#pipes][2]
      bot:load()
      bot.x = top.x
      bot.y = top.height + (bird.height / 2.1)
      bot.scale = {x = 0.7, y = top.scale.y}
      bot.height = bot.image:getHeight() * bot.scale.y
      bot.width = bot.image:getWidth() * bot.scale.x
      bot.visible = true

      local mid = pipes[#pipes][3]
      mid:load()
      mid.x = top.x + (top.width / 2)
      mid.y = top.height
      mid.scale = {x = 0.0001, y = 1}
      mid.height = top.height + (bot.y - top.height)
      mid.width = mid.image:getWidth() * mid.scale.x

      time = 0
    end

    for i = #pipes, 1, -1 do  -- remove pipe in collision with bird
      for j = #pipes[i], 1, -1 do
        if (pipes[i] and pipes[i][j]) then
          local pipe = pipes[i][j]
          pipe:update(delta)
          if (pipe.visible and bird:collision(pipe)) then
            sound.crash:play()
            shake = 0.1
            ended = true
            local life = table.remove(lifes)
            life = (life ~= nil and nil or nil)
          elseif (pipe.x - (pipe.width / 2) < 0 - pipe.width) then
            local removed_pipe = table.remove(pipes, i)
            removed_pipe = (removed_pipe ~= nil and nil or nil)
          elseif (pipes[i][3] and bird.x > pipes[i][3].x) then
            sound.score:play()
            point = point + 1
            local removed_pipe = table.remove(pipes[i], #pipes[i])
            removed_pipe = (removed_pipe ~= nil and nil or nil)
          end
        end
      end
    end
  end
end


function love.draw()
  graphics.setColor(1, 1, 1, 1)
  graphics.draw(back.image, back.x, back.y, 0, back.scale.x, back.scale.y)

  for i = 1, #clouds do
    clouds[i]:draw()
  end

  if (started) then
    if (shake > 0) then
      graphics.translate(math.random(-5, 5), math.random(-5, 5))
    end

    for i = 1, #pipes do  -- draw pipes
      for j = 1, #pipes[i] do
        pipes[i][j]:draw()
      end
    end

    bird:draw() -- draw bird

    for i = 1, #lifes do
      lifes[i]:draw()
    end

    graphics.setColor(0, 0, 0, 1)
    graphics.print(point, CW / 2.1, 30, 0, 2, 2)  -- display points
  else
    graphics.draw(cover.image, cover.x, cover.y, 0, cover.scale.x, cover.scale.y, cover.width / 2, cover.height / 2)
    graphics.setColor(0, 0, 0, 1)
    graphics.print(text.play.title, text.play.x, text.play.y, 0, (text.play.selected and 1.5 or 1), (text.play.selected and 1.5 or 1))
    graphics.print(text.audio.title, text.audio.x, text.audio.y, 0, (text.audio.selected and 1.5 or 1), (text.audio.selected and 1.5 or 1))
    graphics.print("l=toggle \t k/click=jump \t space/click=select \t q=restart", CW / 8, CH - 30, 0, 0.8, 0.8)
  end
end

function love.keypressed(key)
  if (key == "k" and started) then
    sound.flap:play()
    bird.speed.y = -300
  elseif (key == "q") then
    love.event.quit("restart")
  elseif (key == "l" and not started) then
    sound.switch:play()
    if (text.play.selected) then
      text.play.selected = false
      text.audio.selected = true
    elseif (text.audio.selected) then
      text.audio.selected = false
      text.play.selected = true
    end
  elseif (key == "space" and not started) then
    if (text.play.selected) then
      sound.play:play()
      started = true
    elseif (text.audio.selected) then
      if (playing) then
        sound.music:stop()
        playing = false
      else
        sound.music:play()
        playing = true
      end
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  if (button == 1) then
    if (started) then
      sound.flap:play()
      bird.speed.y = -300
    else
      if (x == text.play.x and y == text.play.y) then
        started = true
      end
    end
  end
end
