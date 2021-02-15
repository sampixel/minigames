function love.load()
  love.physics.setMeter(64)
  planet = love.physics.newWorld(0, 9.81*64, true)

  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  love.graphics.setBackgroundColor(0.2, 0.4, 0.9)

  object = {}

  object.ground = {}
  object.ground.body = love.physics.newBody(planet, CW/2, CH-50, "static")
  object.ground.shape = love.physics.newRectangleShape(CW, 50)
  object.ground.fixture = love.physics.newFixture(object.ground.body, object.ground.shape, 1)
  object.ground.fixture:setRestitution(1)

  object.ball = {}
  object.ball.x = CW+10
  object.ball.y = CH/4
  object.ball.radius = 20
  object.ball.density = 1
  object.ball.speed = 100
  object.ball.left = true
  object.ball.right = false
  object.ball.body = love.physics.newBody(planet, object.ball.x, object.ball.y, "dynamic")
  object.ball.shape = love.physics.newCircleShape(object.ball.radius)
  object.ball.fixture = love.physics.newFixture(object.ball.body, object.ball.shape, object.ball.density)
  object.ball.fixture:setRestitution(1)
end

function love.update(dt)
  planet:update(dt)

  if (object.ball.body:getX() >= CW - object.ball.shape:getRadius()) then
    object.ball.body:applyLinearImpulse(-10, 0)
  elseif (object.ball.body:getX() - object.ball.shape:getRadius()/2 <= 0) then
    object.ball.body:applyLinearImpulse(10, 0) 
  end

  --[[
  if (object.ball.left) then
    object.ball.body:applyForce(-20, 0)
    --object.ball.body:applyImpulse(-100, 0, object.ball.body:getX(), object.ball.body:getY())
  elseif (object.ball.right) then
    object.ball.body:applyForce(20, 0)
    --object.ball.body:applyImpulse(100, 0, object.ball.body:getX(), object.ball.body:getY())
  end
  --]]

  print(object.ball.body:getX())
end

function love.draw()
  love.graphics.setColor(0.2, 0.6, 0.1)
  love.graphics.polygon("fill", object.ground.body:getWorldPoints(object.ground.shape:getPoints()))

  love.graphics.setColor(0.7, 0.2, 0.1)
  love.graphics.circle("fill", object.ball.body:getX(), object.ball.body:getY(), object.ball.shape:getRadius())
end
