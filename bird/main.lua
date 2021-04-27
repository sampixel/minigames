function love.load()
  class = require("libs.class")   -- require modules
  object = require("libs.object")
  sound = require("libs.sound")

  CW = love.graphics.getWidth() -- coordinates window
  CH = love.graphics.getHeight()

  point = 0 -- forward variables
  time = 0
  gap = 2
  started = false
  ended = false

  back = class:extend(object.image) -- background
  back:load()

  bird = class:extend(object.bird)  -- bird
  bird:load()
  bird.frame.width = bird.width * bird.scale.x / bird.frame.num_width
  bird.frame.height = bird.height * bird.scale.y / bird.frame.num_height
  bird.sheets = {}

  for i = 0, bird.frame.num_height - 1 do  -- load quads image
    local size = 128
    for j = 0, bird.frame.num_width - 1 do
      table.insert(bird.sheets, love.graphics.newQuad(
        j * size, i * size, size, size,
        bird.width, bird.height
      ))
    end
  end

  pipes = {}  -- pipes
end


function love.update(delta)
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
    top.height = love.math.random(50, 300)
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


function love.draw()
  love.graphics.setColor(1, 1, 1, 1)

  back:draw() -- draw background
  bird:draw() -- draw bird

  for i = 1, #pipes do  -- draw pipes
    for j = 1, #pipes[i] do
      pipes[i][j]:draw()
    end
  end

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print("point: " .. point, 50, 50, 0, 2, 2)  -- display points
end


function love.keypressed(key)
  if (key == "k") then
    sound.flap:play()
    bird.speed.y = -300
  elseif (key == "return") then
    print(#pipes)
    print(#pipes[1])
    print(#pipes[1][1])
  end
end
