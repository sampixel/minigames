function love.load()
  class = require("libs.class")
  object = require("libs.object")
  sounds = require("libs.sounds")

  cw = love.graphics.getWidth()
  ch = love.graphics.getHeight()

  b_logo = class:extend(object.call("bullet.logo"))
  b_logo:load()
  b_number = class:extend(object.call("bullet.number"))
  points = class:extend(object.call("points"))
  panda = class:extend(object.call("panda"))
  panda:load()
  viper = class:extend(object.call("viper"))
  viper:load()

  -- table for bullets
  bullets = {}
end

function love.update(delta)
  panda:update(delta)
  viper:update(delta)
  points:update(delta)

  for i, v in ipairs(bullets) do 
    v:update(delta)

    if (v:checkcollision(viper)) then
      points.text = points.text + 1
      table.remove(bullets, i)
      sounds.gotcha:play()
    elseif ((v.y + v.height) > ch) then
      table.remove(bullets, i)
      sounds.out:play()
    end
  end
end

function love.draw()
  b_logo:draw()
  b_number:print()
  points:print()
  panda:draw()
  viper:draw()

  for _, v in ipairs(bullets) do
    v:load()
    v:draw() 
  end
end

function love.keypressed(key)
  if (key == "space") then
    if (b_number.text < 1) then
      b_number.text = 0
      sounds.stop:play()
    else
      table.insert(bullets, class:extend({
        filename = "bullet",
        x = panda.x + (panda.width/2),
        y = panda.y + (panda.height/2),
        speed = 500,
        width = 10,
        height = 34,
        update = function(self, delta)
          self.y = self.y + (self.speed * delta)
        end
      }))

      sounds.shot:play()
      b_number.text = b_number.text - 1
      panda.speed = panda.speed + 10
      viper.speed = viper.speed + 50
    end
  end
end
