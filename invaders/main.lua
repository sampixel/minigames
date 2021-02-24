function love.load()
  class = require("libs.class")
  object = require("libs.object")
  util = require("libs.util")

  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()
  
  math.randomseed(os.time())

  player = class:extend(object["player"])
  player.scaleX = 0.5
  player.scaleY = 0.8
  player:load()
  player.x = CW/2 - player.width/2
  player.y = CH - player.height
  player.lives = 3

  bullets = {}
  bullets.player = {}
  bullets.enemies = {}

  enemies = {}
  for i = 1, 3 do
    for j = 1, 10 do
      table.insert(enemies, class:extend({
        filename = "invador",
        speed = 80,
        update = function(self, dt)
          self.x = self.x + self.speed * dt

          if (self.x + self.width >= CW) or (self.x <= 0) then
            for i, _ in ipairs(enemies) do
              enemies[i].speed = -enemies[i].speed
              enemies[i].y = enemies[i].y + 50
            end
          end

          for i, _ in ipairs(bullets.player) do
            if (self:collision(bullets.player[i])) then
              table.remove(bullets.player, i)
            end
          end
        end,
        shot = function(self, idx, dt)
          table.insert(bullets.enemies, class:extend({
            filename = "invadors_bullet",
            speed = 50,
            scaleX = 0.2,
            scaleY = 0.5,
            update = function(self, dt)
              self.y = self.y + self.speed * dt
              self.speed = self.speed + 10
            end
          }))

          bullets.enemies[#bullets.enemies]:load()
          bullets.enemies[#bullets.enemies].x = enemies[idx].x + enemies[idx].width/2
          bullets.enemies[#bullets.enemies].y = enemies[idx].y + enemies[idx].height
        end
      }))
      
      enemies[#enemies]:load()
      enemies[#enemies].x = j * enemies[#enemies].width
      enemies[#enemies].y = i * enemies[#enemies].height
    end
  end
end


function love.update(dt)
  player:update(dt)

  for i, _ in ipairs(enemies) do
    enemies[i]:update(dt) 

    if (math.random(1000) == i) then
      enemies[i]:shot(i, dt)
    end
  end

  util.checktable(bullets.player, dt)
  util.checktable(bullets.enemies, dt)
end


function love.draw()
  util.draw(bullets.player)
  util.draw(bullets.enemies)
  util.draw(enemies)
  player:draw()
end


function love.keypressed(key)
  if (key == "space") then
    table.insert(bullets.player, class:extend({
      filename = "player_bullet",
      speed = 50,
      scaleX = 0.2,
      scaleY = 0.5,
      update = function(self, dt)
        self.y = self.y - self.speed * dt
        self.speed = self.speed + 10

        for i, _ in ipairs(enemies) do
          if (self:collision(enemies[i])) then
            table.remove(enemies, i)
          end
        end
      end
    }))

    bullets.player[#bullets.player]:load()
    bullets.player[#bullets.player].x = player.x + player.width/2
    bullets.player[#bullets.player].y = player.y
  end
end
