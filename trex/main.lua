function love.load()
  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  time = 0
  gap = math.random(3) 
  jump = love.audio.newSource("audio/jump.wav", "stream")
  reward = love.audio.newSource("audio/reward.wav", "stream")
  crash = love.audio.newSource("audio/crash.wav", "stream")

  point = {}
  point.text = 0
  point.x = CW - 100
  point.y = 50

  game = {}
  game.text = "GAME OVER"
  game.x = 50
  game.y = 50
  game.isOver = false

  ground = {}
  ground.x1 = 0
  ground.x2 = CW
  ground.y1 = CH - 50
  ground.y2 = CH - 50

  trex = {}
  trex.image = love.graphics.newImage("images/trex.png")
  trex.width = trex.image:getWidth()*0.2
  trex.height = trex.image:getHeight()*0.2
  trex.x = 100
  trex.y = ground.y1 - trex.height - 1
  trex.speed = 50
  trex.jump = true

  cactus = {}
end


function love.update(dt)
  if not (game.isOver) then
    time = time + dt
    
    trex.y = trex.y + (trex.speed * dt)
    trex.speed = trex.speed + 20

    if (trex.y + trex.height > ground.y1) then
      trex.y = ground.y1 - trex.height
    end

    if (time > gap) then
      table.insert(cactus, {
        image = love.graphics.newImage("images/cactus" .. math.random(3) .. ".png"),
        speed = math.random(100, 400),
        reward = math.random(50),
        x = CW
      })
  
      local last_cactus = cactus[#cactus]
      last_cactus.width = last_cactus.image:getWidth()*0.1
      last_cactus.height = last_cactus.image:getHeight()*0.1
      last_cactus.y = ground.y1 - last_cactus.height

      time = 0
      gap = math.random(3)
    end

    for i, v in ipairs(cactus) do
      v.x = v.x - (v.speed * dt)

      if ((v.x + v.width - 20> trex.x) and (v.x < trex.x + trex.width - 20) and
          (v.y + v.height - 20 > trex.y) and (v.y < trex.y + trex.height - 20)) then
        crash:play()
        game.isOver = true
      elseif (trex.x > v.x + v.width) then
        point.text = point.text + v.reward
        reward:play()
      end

      if (v.x < 0 - v.width) then
        table.remove(cactus, i)
      end
    end
  end
end


function love.draw()
  love.graphics.print(string.format("%05d", point.text), point.x, point.y, 0, 1.5, 1.5)
  love.graphics.line(ground.x1, ground.y1, ground.x2, ground.y2)
  love.graphics.draw(trex.image, trex.x, trex.y, 0, 0.2, 0.2)

  for _, v in ipairs(cactus) do
    love.graphics.draw(v.image, v.x, v.y, 0, 0.1, 0.1)
  end

  if (game.isOver) then
    love.graphics.print(game.text, game.x, game.y, 0, 3, 3)
  end
end


function love.keypressed(key)
  if ((key == "space") and not (game.isOver) and (trex.jump)) then
    jump:play()
    trex.speed = -500
  elseif ((key == "return") and (game.isOver)) then
    for i = #cactus, 1, -1 do
      table.remove(cactus, i)
    end
    point.text = 0
    game.isOver = false
  end
end
