function love.load()
  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  smash = love.audio.newSource("audio/smash.wav", "stream")
  pok = love.audio.newSource("audio/pok.wav", "stream")
  lose = love.audio.newSource("audio/lose.wav", "stream")

  rects = {}
  rects[1] = {}
  rects[2] = {}
  rects[3] = {}

  cols = 10
  rows = 3

  for i = 1, rows do
    for j = 1, cols do
      table.insert(rects[i], {
        width = 40,
        height = 10,
        x = j * 70,
        y = i * 50,
        dead = false,
        remove = function(self)
          self.dead = true
          smash:play() 
        end
      })
    end
  end

  player = {}
  player.width = 50
  player.height = 15
  player.speed = 500
  player.x = (CW / 2) - (player.width / 2)
  player.y = CH - player.height * 2

  ball = {}
  ball.speedX = 250
  ball.speedY = 250
  ball.width = 5
  ball.height = 5
  ball.x = player.x + (player.width/2)
  ball.y = player.y - (player.height/2)
end


function love.update(dt)
  ball.vx, ball.vy = ball.speedX * dt, ball.speedY * dt

  ball.x = ball.x + ball.speedX * dt
  ball.y = ball.y - ball.speedY * dt
  
  if (ball.x + ball.width >= CW) then
    pok:play()
    ball.speedX = -ball.speedX
  end

  if (ball.x <= 0) then
    pok:play()
    ball.speedX = -ball.speedX
  end

  if (ball.y <= 0) then
    pok:play()
    ball.speedY = -ball.speedY
  end
  
  if (ball.y + ball.height >= CH) then
    lose:play()
    player.x = (CW/2) - player.width/2
    player.y = CH - player.height*2
    ball.x = player.x + (player.width/2)
    ball.y = player.y - (player.height/2)
  end

  if ((ball.y + ball.height >= player.y) and (ball.x + ball.width >= player.x) and (ball.x <= player.x + player.width)) then
    pok:play()
    ball.speedY = -ball.speedY
  end

  if (player.x <= 0) then
    player.x = 0
  elseif (player.x + player.width >= CW) then
    player.x = CW - player.width
  end

  if (love.keyboard.isDown("h")) then
    player.x = player.x - player.speed * dt 
  elseif (love.keyboard.isDown("l")) then
    player.x = player.x + player.speed * dt
  end

  for i, row in ipairs(rects) do
    for j, col in ipairs(row) do
      if not (row[j].dead) then
        if ((ball.y <= row[j].y + row[j].height) and
            (ball.y > row[j].y) and (ball.x >= row[j].x - ball.width/2) and
            (ball.x <= row[j].x + row[j].width - ball.width/2)) then
          ball.speedY = -ball.speedY
          row[j]:remove()
        elseif ((ball.y + ball.height >= row[j].y) and (ball.y < row[j].y) and
              (ball.x >= row[j].x - ball.width/2) and (ball.x <= row[j].x + row[j].width - ball.width/2)) then
          ball.speedY = -ball.speedY
          row[j]:remove()
        elseif ((ball.x + ball.width >= row[j].x) and (ball.x < row[j].x) and
              (ball.y <= row[j].y + row[j].height) and (ball.y + ball.height >= row[j].y)) then
          ball.speedX = -ball.speedX
          row[j]:remove()
        elseif ((ball.x <= row[j].x + row[j].width) and (ball.x + ball.width > row[j].x + row[j].width) and
              (ball.y <= row[j].y + row[j].height) and (ball.y + ball.height >= row[j].y)) then
          ball.speedX = ball.speedX
          row[j]:remove()
        end
      end
    end
  end
end


function love.draw()
  love.graphics.setColor(1, 1, 1)

  love.graphics.print("xVelocity: " .. ball.vx .. "\nyVelocity: " .. ball.vy, 50, CH - 100, 0, 1.2, 1.2)

  for i = 1, #rects do
    for j = 1, #rects[i] do
      if not (rects[i][j].dead) then
        love.graphics.rectangle("fill", rects[i][j].x, rects[i][j].y, rects[i][j].width, rects[i][j].height)
      end
    end
  end

  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
  love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
end
