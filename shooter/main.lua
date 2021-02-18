function love.load()
  class = require("libs.class")
  object = require("libs.object")
  sound = require("libs.sound")
  util = require("libs.util")

  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  back = class:extend(object["back"])
  back:load()

  grass = class:extend(object["grass"])
  grass:load()

  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)

  ball = {}
  ball.body = love.physics.newBody(world, CW/2, CH/4, "dynamic")
  ball.shape = love.physics.newCircleShape(30)
  ball.fixture = love.physics.newFixture(
    ball.body, ball.shape, 1
  ):setRestitution(1)

  ball.score = {}
  ball.score.num = 30
  ball.score.x = 0
  ball.score.y = 0
  ball.isStarted = false

  ground = {}
  ground.body = love.physics.newBody(world, CW/2, CH-20, "static")
  ground.shape = love.physics.newRectangleShape(CW, 40)
  ground.fixture = love.physics.newFixture(
    ground.body, ground.shape, 1
  ):setRestitution(1)

  bullets = {}

  shooter = class:extend(object["shooter"]) 
  shooter:load()
  shooter.frame_width = shooter.width/6
  shooter.frame_height = shooter.height/2
  shooter.x = 50
  shooter.y = CH - shooter.frame_height - 40

  for i = 0, 1 do
    for j = 0, 5 do
      table.insert(
        shooter.frames,
        love.graphics.newQuad(
          j * shooter.frame_width, i * shooter.frame_height,
          shooter.frame_width, shooter.frame_height,
          shooter.width, shooter.height
      ))
    end
  end

  health = {}
  health.text = "health: "
  health.x = CW - 250
  health.y = CH - 30
end


function love.update(dt)
  world:update(dt)
  grass:update(dt)
  shooter:update(dt)

  ball.score.x = ball.body:getX()
  ball.score.y = ball.body:getY()

  if not (ball.isStarted) then
    ball.body:applyLinearImpulse(150, 0)
    ball.isStarted = true
  end

  if ((ball.body:getX() + ball.shape:getRadius() >= CW) or
      (ball.body:getX() - ball.shape:getRadius() <= 0)) then
    local vx = ball.body:getLinearVelocity()
    ball.body:applyLinearImpulse(-vx * 2, 0)
  end

  if (util.checkDistance(ball, shooter)) then
    shooter.lives = shooter.lives - 1
    if (shooter.lives < 1) then  
      sound.scream:play()
      shooter.lives = 0
      print("Game Over")
    else
      sound.ouch:play()
      shooter.x = CW - (shooter.width / 2)
    end
  end

  for i = 1, #bullets do
    if (bullets[i]) then
      bullets[i]:update(dt)

      if (util.checkDistance(ball, bullets[i])) then
        sound.explosion:play()
        table.remove(bullets, i)
        if (ball.score.num <= 0) then
          print("You Win")
        else
          ball.score.num = ball.score.num - 1
        end
      elseif (bullets[i].y <= 0 - bullets[i].height) then
        table.remove(bullets, i)
      end
    end
  end
end


function love.draw()
  back:draw()
  grass:draw()

  for i = 1, #bullets do
    bullets[i]:draw()
  end

  love.graphics.draw(
    shooter.image,
    shooter.frames[math.floor(shooter.current_frame)],
    shooter.x, shooter.y, 0, shooter.xScale, shooter.yScale,
    shooter.frame_width/2, 1
  )

  love.graphics.setColor(0.2, 0.9, 0.2)
  love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))
  love.graphics.setColor(0.9, 0.2, 0.2)
  love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

  love.graphics.setColor(0, 0, 0)
  love.graphics.print(ball.score.num, ball.score.x - ball.shape:getRadius()/2, ball.score.y - ball.shape:getRadius()/2, 0, 2, 2)
  love.graphics.print(health.text .. shooter.lives, health.x, health.y, 0, 2, 2)

  love.graphics.setColor(1, 1, 1, 1)
end


function love.keypressed(key)
  if (key == "space") then
    sound.laser:play()
    table.insert(bullets, class:extend({
      filename = "bullet",
      x = shooter.x,
      y = shooter.y,
      xScale = 0.2, yScale = 0.6,
      speed = 150,
      update = function(self, dt)
        self.y = self.y - self.speed * dt
        self.speed = self.speed + 20
      end
    }))

    bullets[#bullets]:load()
  end

  if (key == "h") or (key == "l") then
    shooter.status = "walking"
    shooter.current_frame = 7 
  end
end


function love.keyreleased(key)
  if (key == "h") or (key == "l") then
    shooter.status = "idle"
    shooter.current_frame = 1
  end
end
