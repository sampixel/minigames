function love.load()
  mod = require("libs.mod")

  cw = love.graphics.getWidth()
  ch = love.graphics.getHeight()

  circle = {}
  circle.x = 200
  circle.y = 300
  circle.radius = 50
  circle.speed = 200

  score = 0
  timer = 15

  font = love.graphics.newFont(30)
  start = love.audio.newSource("audio/start.wav", "stream")
  stop = love.audio.newSource("audio/warning.wav", "stream")
end

function love.draw()
  love.graphics.setColor(35, 90, 12)
  love.graphics.circle("fill", circle.x, circle.y, circle.radius)

  love.graphics.setFont(font)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(score, cw - 50, ch - 50)
  love.graphics.print(string.sub(timer, 1, 4) .. " seconds left", cw / 2, 30)
end

function love.update(dt)
  if (isStarted) then
    timer = timer - (1/60)

    if (timer < 0) then
      timer = 0 
      stop:play()
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  if (button == 1) then
    if not (isStarted) then
      isStarted = true
      start:play()
    end

    if (mod.distance(circle.x, circle.y, love.mouse.getX(), love.mouse.getY()) <= circle.radius) then
      score = score + 1
      circle.x = math.random(0 + circle.radius * 2, cw)
      circle.y = math.random(0 + circle.radius * 2, ch)
    end
  end
end
