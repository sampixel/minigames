function love.load()
  class = require("libs.class")
  object = require("libs.object")

  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  love.graphics.setBackgroundColor(0.2, 0.3, 0.7)

  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)

  ball = {}
  ball.body = love.physics.newBody(world, CW/2, CH/4, "dynamic")
  ball.shape = love.physics.newCircleShape(50)
  ball.fixture = love.physics.newFixture(
    ball.body, ball.shape, 1
  ):setRestitution(1)

  ground = {}
  ground.body = love.physics.newBody(world, CW/2, CH-20, "static")
  ground.shape = love.physics.newRectangleShape(CW, 40)
  ground.fixture = love.physics.newFixture(
    ground.body, ground.shape, 1
  ):setRestitution(1)

  bullets = {}

  shooter = class:extend(object["shooter"]) 
  shooter:load()
  shooter.width = shooter.width/6
  shooter.height = shooter.height/2
  shooter.x = 50
  shooter.y = CH - shooter.height - 40

  for i = 0, 1 do
    for j = 0, 5 do
      table.insert(
        shooter.frames,
        love.graphics.newQuad(
          j * shooter.framewidth, i * shooter.frameheight,
          shooter.framewidth, shooter.frameheight,
          shooter.x, shooter.y
      ))
    end
  end
end

function love.update(dt)
  world:update(dt)
  shooter:update(dt)

  --[[
  if (shooter:checkCollision(ball)) then
    shooter.lives = shooter.lives <= 0 and 0 or shooter.lives - 1
    print("shooter collides with enemy", shooter.lives)
  end
  --]]

  for i = 1, #bullets do
    if (bullets[i]) then
      bullets[i]:update(dt)

      if (bullets[i].y <= 0 - bullets[i].height) then
        table.remove(bullets, i)
      end

      --[[
      if (bullets[i]:checkCollision(ball)) then
        table.remove(bullets, i)
      end
      --]]
    end
  end
end

function love.draw()
  for i = 1, #bullets do
    bullets[i]:draw()
  end

  love.graphics.draw(shooter.image, shooter.frames[math.floor(shooter.currentframe)], shooter.x, shooter.y)

  love.graphics.setColor(0.2, 0.9, 0.2)
  love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
  love.graphics.setColor(0.9, 0.2, 0.2)
  love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

  love.graphics.setColor(1, 1, 1, 1)
end

function love.keypressed(key)
  if (key == "space") then
    table.insert(bullets, class:extend({
      filename = "bullet",
      x = shooter.x,
      y = shooter.y,
      xs = 0.2, ys = 0.6,
      speed = 100,
      update = function(self, dt)
        self.y = self.y - self.speed * dt
        self.speed = self.speed + 20
      end
    }))

    bullets[#bullets]:load()
  end
end

function love.keyreleased(key)
  if (key == "h") or (key == "l") then
    shooter.status = "idle"
    shooter.currentframe = 1
  end
end
