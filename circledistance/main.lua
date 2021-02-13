function love.load()
  circle = {}
  circle.x = 100
  circle.y = 200
  circle.radius = 60
  circle.speed = 200
end

function love.update(delta)
  xmouse, ymouse = love.mouse.getPosition()
  angle = math.atan2(ymouse - circle.y, xmouse - circle.x)

  cos = math.cos(angle)
  sin = math.sin(angle)

  circle.x = circle.x + circle.speed * cos * delta
  circle.y = circle.y + circle.speed * sin * delta
end

function love.draw()
  love.graphics.circle("line", circle.x, circle.y, circle.radius)
  love.graphics.print("angle: " .. angle, 20, 10)
  love.graphics.line(circle.x, circle.y, xmouse, circle.y)
  love.graphics.line(circle.x, circle.y, circle.x, ymouse)
  love.graphics.line(circle.x, circle.y, xmouse, ymouse)
end
