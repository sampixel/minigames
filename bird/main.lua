function love.load()
  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  point = 0
  time = 0
  gap = 2

  flap = love.audio.newSource("audio/flap.wav", "stream")
  score = love.audio.newSource("audio/score.wav", "stream")
  crash = love.audio.newSource("audio/crash.wav", "stream")

  back = {}
  back.image = love.graphics.newImage("images/background.png")
  back.width = back.image:getWidth()
  back.height = back.image:getHeight()
  back.scaleX = 0.5
  back.scaleY = 0.4

  bird = {}
  bird.image = love.graphics.newImage("images/bird.png")
  bird.width = bird.image:getWidth()/5
  bird.height = bird.image:getHeight()/5
  bird.x = CW/3
  bird.y = CH/4
  bird.scaleX = 0.2
  bird.scaleY = 0.2
  bird.speed = 0

  pipes = {}
end


function love.update(dt)
  bird.y = bird.y + bird.speed * dt
  bird.speed = bird.speed + 10

  for i = #pipes, 1, -1 do
    for j = #pipes[i], 1, -1 do
      pipes[i][j].x = pipes[i][j].x - pipes[i][j].speed * dt

      if ((pipes[i][j].x + pipes[i][j].width > bird.x) and (pipes[i][j].x < bird.x + bird.width) and
          (pipes[i][j].y + pipes[i][j].height > bird.y) and (pipes[i][j].y < bird.y + bird.height)) then
        crash:play()
      end

      if (pipes[i][j].x < 0 - pipes[i][j].width) then
        table.remove(pipes, i)
      end

      if (pipes[i][3] and bird.x > pipes[i][3].x) then
        score:play()
        point = point + 1
        table.remove(pipes[i], #pipes[i])
      end
    end
  end

  time = time + dt

  if (time > gap) then
    table.insert(pipes, {})

    for i = 1, 3 do
      table.insert(pipes[#pipes], {
        image = love.graphics.newImage("images/pipe.png"),
        speed = 150
      })

      pipes[#pipes][i].width = pipes[#pipes][i].image:getWidth()
    end

    local top = pipes[#pipes][1]
    local bot = pipes[#pipes][2]
    local mid = pipes[#pipes][3]

    top.x = CW
    top.y = 0
    top.height = math.random(50, 300)
    top.scaleX = 0.5
    top.scaleY = -1

    bot.x = top.x
    bot.y = CH + (top.height - bird.height)
    bot.height = CH - (top.height + 100)
    bot.scaleX = 0.5
    bot.scaleY = 1

    mid.x = top.x
    mid.y = top.y + top.height
    mid.height = CH - (bot.height + top.height)
    mid.scaleX = 0.001
    mid.scaleY = 1

    time = 0
  end
end


function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(back.image, 0, 0, 0, back.scaleX, back.scaleY)
  love.graphics.draw(bird.image, bird.x, bird.y, 0, bird.scaleX, bird.scaleY)
  
  love.graphics.setColor(0, 1, 0)
  for i = 1, #pipes do
    for j = 1, #pipes[i] do
      love.graphics.draw(
        pipes[i][j].image, pipes[i][j].x, pipes[i][j].y,
        0, pipes[i][j].scaleX, pipes[i][j].scaleY,
        pipes[i][j].image:getWidth()/2, pipes[i][j].image:getHeight()/2
      )
    end
  end

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print("point: " .. point, 50, 50, 0, 2, 2)
end


function love.keypressed(key)
  if (key == "k") then
    flap:play()
    bird.speed = -150
  end
end
