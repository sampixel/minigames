local graphics = love.graphics
local math = love.math

function love.load()
  class = require("libs.class")   -- require modules
  object = require("libs.object")
  sound = require("libs.sound")

  CW = graphics.getWidth() -- coordinates window
  CH = graphics.getHeight()

  graphics.setNewFont("font/SuperMarioDsRegular-Ea4R8.ttf", 20)

  point = 0 -- forward variables
  time = 0
  gap = 2
  started = false
  ended = false

  back = {} -- background
  back.image = graphics.newImage("images/background.png")
  back.width = back.image:getWidth()
  back.height = back.image:getHeight()
  back.scale = {x = 0.5, y = 0.4}

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
        x = "0." .. math.random(3, 9),
        y = "0." .. math.random(3, 9)
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
    table.insert(clouds, cloud)
  end

  bird = class:extend(object.bird)  -- bird
  bird:load()
  bird.frame.width = bird.width * bird.scale.x / bird.frame.num_width
  bird.frame.height = bird.height * bird.scale.y / bird.frame.num_height
  bird.sheets = {}

  for i = 0, bird.frame.num_height - 1 do  -- load quads image
    local size = 128
    for j = 0, bird.frame.num_width - 1 do
      table.insert(bird.sheets, graphics.newQuad(
        j * size, i * size, size, size,
        bird.width, bird.height
      ))
    end
  end

  pipes = {}  -- pipes
end 

function love.update(delta)
  for i = 1, #clouds do
    clouds[i]:update(delta)
  end

  if (started) then
    bird:update(delta)  -- update bird

    time = time + delta

    if (time > gap) then  -- create 3 pipes when time reaches limit
      table.insert(pipes, {})

      for i = 1, 3 do
        table.insert(pipes[#pipes], class:extend(object.pipe))
      end

      local top = pipes[#pipes][1]
      top:load()
      top.x = CW
      top.y = 0
      top.height = math.random(50, 300)
      top.scale = {x = 2, y = -1}

      local bot = pipes[#pipes][2]
      bot:load()
      bot.x = top.x
      bot.y = top.height + bird.height
      bot.scale = {x = 2, y = 1}

      local mid = pipes[#pipes][3]
      mid:load()
      mid.x = top.x + top.width
      mid.y = top.height
      mid.height = top.height + (bot.y - top.height)
      mid.scale = {x = 0.0001, y = 1}

      time = 0
    end

    for i = #pipes, 1, -1 do  -- remove pipe in collision with bird
      for j = #pipes[i], 1, -1 do
        if (pipes[i] and pipes[i][j]) then
          local pipe = pipes[i][j]
          pipe:update(delta)
          if (bird:collision(pipe)) then
            sound.crash:play()
            ended = true
          elseif (pipe.x < 0 - pipe.width) then
            table.remove(pipes, i)
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

  if (started) then
    bird:draw() -- draw bird

    for i = 1, #pipes do  -- draw pipes
      for j = 1, #pipes[i] do
        pipes[i][j]:draw()
      end
    end

    graphics.setColor(0, 0, 0, 1)
    graphics.print("point: " .. point, 50, 50, 0, 2, 2)  -- display points
  else
    graphics.draw(cover.image, cover.x, cover.y, 0, cover.scale.x, cover.scale.y, cover.width / 2, cover.height / 2)
    graphics.setColor(0, 0, 0, 1)
    graphics.print(text.play.title, text.play.x, text.play.y, 0, (text.play.selected and 1.5 or 1), (text.play.selected and 1.5 or 1))
    graphics.print(text.audio.title, text.audio.x, text.audio.y, 0, (text.audio.selected and 1.5 or 1), (text.audio.selected and 1.5 or 1))
    graphics.print("l=toggle \t k/click=jump \t space/click=select \t", CW / 4.5, CH - 30, 0, 0.8, 0.8)
  end
end


function love.keypressed(key)
  if (key == "k" and started) then
    sound.flap:play()
    bird.speed.y = -300
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
    end
  end
end
