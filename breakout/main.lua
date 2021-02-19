function love.load()
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
        y = i * 50
      })
    end
  end

  player = {}
  player.width = 50
  player.height = 15
  player.speed = 500
  player.x = (love.graphics.getWidth() / 2) - (player.width / 2)
  player.y = love.graphics.getHeight() - player.height * 2

  circle = {}
  circle.speedX = 250
  circle.speedY = 250
  circle.radius = 5
  circle.x = player.x + (player.width/2)
  circle.y = player.y - (player.height/2)

  smash = love.audio.newSource("audio/smash.wav", "stream")
end


function love.update(dt)
  if ((circle.x - circle.radius <= 0) or
      (circle.x + circle.radius >= love.graphics.getWidth())) then
    circle.speedX = -circle.speedX
  end

  if ((circle.y - circle.radius <= 0) or
      (circle.y + circle.radius >= love.graphics.getHeight())) then
    circle.speedY = -circle.speedY
  end

  circle.x = circle.x + circle.speedX * dt
  circle.y = circle.y + circle.speedY * dt

  if (love.keyboard.isDown("h")) then
    player.x = player.x - player.speed * dt 
  elseif (love.keyboard.isDown("l")) then
    player.x = player.x + player.speed * dt
  end

  if ((circle.y + circle.radius >= player.y) and
      (circle.x + circle.radius >= player.x) and
      (circle.x - circle.radius <= player.x + player.width)) then
    circle.speedY = -circle.speedY
  end

  for i, row in ipairs(rects) do
    for j, col in ipairs(row) do
      if (row[j]) then
        if ((circle.y + circle.radius >= row[j].y) and
            (circle.x + circle.radius >= row[j].x) and
            (circle.x - circle.radius <= row[j].x + row[j].width) and
            (circle.y - circle.radius <= row[j].y + row[j].height)) then
          smash:play()
          circle.speedY = -circle.speedY
          row[j] = nil
        end
      end
    end
  end
end


function love.draw()
  love.graphics.setColor(1, 1, 1)

  for i = 1, #rects do
    for j = 1, #rects[i] do
      if (rects[i][j]) then
        love.graphics.rectangle("fill", rects[i][j].x, rects[i][j].y, rects[i][j].width, rects[i][j].height)
      end
    end
  end

  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
  love.graphics.circle("fill", circle.x, circle.y, circle.radius)
end
