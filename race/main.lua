function love.load()
  class = require("libs.class")

  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  player = {}

  player.left = class:extend({filename = "left"})
  player.left:load()
  player.left.x = CW/3
  player.left.y = CH - player.left.height*1.2
  player.left.speed = 100
  player.left.score = 0
  player.left.upButton = "w"
  player.left.downButton = "s"

  player.right = class:extend({filename = "right"})
  player.right:load()
  player.right.x = CW/1.5
  player.right.y = CH - player.right.height*1.2
  player.right.speed = 100
  player.right.score = 0
  player.right.upButton = "k"
  player.right.downButton = "j"

  enemies = {}
  for i = 1, 20 do
    table.insert(enemies, {
      speed = math.random(250),
      width = math.random(10),
      height =  math.random(10),
      y = math.random(tonumber(CH)-100),
      toRight = false,
      toLeft = false,
      update = function(self, dt)
        if (self.toRight) then
          self.x = self.x + self.speed * dt
        elseif (self.toLeft) then
          self.x = self.x - self.speed * dt
        end

        if (self.x >= CW) then
          self.toRight = false
          self.toLeft = true
        elseif (self.x + self.width <= 0) then
          self.toLeft = false
          self.toRight = true
        end
      end
    })
    
    if (math.random(1) == 0) then
      enemies[#enemies].x = 0 - enemies[#enemies].width
      enemies[#enemies].toRight = true
    else
      enemies[#enemies].x = CW + enemies[#enemies].width
      enemies[#enemies].toLeft = true
    end
  end
end


function love.update(dt)
  player.left:update(dt)
  player.left:collision(enemies)

  player.right:update(dt)
  player.right:collision(enemies)

  for i, _ in ipairs(enemies) do
    enemies[i]:update(dt)
  end
end


function love.draw()
  player.left:draw()
  player.right:draw()

  love.graphics.print(player.left.score, 50, CH-50, 0, 2, 2)
  love.graphics.print(player.right.score, CW-50, CH-50, 0, 2, 2)

  for i, _ in ipairs(enemies) do
    love.graphics.rectangle("fill", enemies[i].x, enemies[i].y, enemies[i].width, enemies[i].height)
  end
end

function love.keypressed(key)
  if (key == "return") then
    love.event.quit("restart")
  end
end
