local graphics = love.graphics
local keyboard = love.keyboard
local random = love.math.random
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local elite = require("libs.elite")
local stalkerx = require("libs.camera")
local windfield = require("libs.windfield")
local sound = require("libs.sound")

local score = 0
local landed = false
local over = false

function love.load()
  elite.setImageDir("images")
  camera = stalkerx()
  camera:setFollowLerp(2)
  camera:setFollowLead(10)

  world = windfield.newWorld(0, 0, false)
  world:setGravity(0, 9.81*128)
  world:addCollisionClass("cube")
  world:addCollisionClass("grass")

  graphics.setFont(graphics.newFont("fonts/Zyana-Regular.ttf", 20))
  graphics.setBackgroundColor(0.4, 0.55, 1, 0.8)

  clouds = {}
  for i = 1, 6 do
    local randnum = "0." .. random(3)
    local cloud = elite:extend({
      filename = "cloud_" .. i .. ".png",
      x = random(0, cw),
      y = random(0, ch / 1.8),
      scale = {x = randnum, y = randnum},
      speed = {x = random(1) == 1 and random(-100, -20) or random(20, 100)},
      update = function(self, delta)
        self.x = self.x + (self.speed.x * delta)
        if (self.x > cw or self.x + self.width < 0) then
          self.y = random(0, ch / 1.8)
          self.speed.x = -self.speed.x
        end
      end
    })
    cloud:setMode("norm")
    cloud:load(1)
    table.insert(clouds, cloud)
  end

  grass = elite:extend({
    filename = "grass_platform.png",
    scale = {x = 1.5, y = 0.18}
  })
  grass:setMode("norm")
  grass:load()
  grass.x = 0
  grass.y = ch - (grass.height * grass.scale.y)
  grass.body = world:newRectangleCollider(grass.x, grass.y, grass.width * grass.scale.x, grass.height * grass.scale.y)
  grass.body:setCollisionClass("grass")
  grass.body:setType("static")

  dcube = elite:extend({
    filename = "wood.png",
    scale = {x = 0.08, y = 0.08},
    speed = {x = 200},
    update = function(self, delta)
      self.x = self.x + (self.speed.x * delta)
      if (self.x + self.width > cw or self.x < 0) then
        self.speed.x = -self.speed.x
      end
    end
  })
  dcube:setMode("norm")
  dcube:load(1)
  dcube.x = 0 + dcube.width
  dcube.y = 0 + (dcube.height / 2)

  cubes = {}
end

function love.update(delta)
  camera:update(delta)
  --[[
  camera:follow(
    #cubes > 1 and cubes[#cubes-1].body:getX(),
    #cubes > 1 and cubes[#cubes-1].body:getY()
  )
  --]]
  
  world:update(delta)

  for i = 1, #clouds do
    clouds[i]:update(delta)
  end

  if (not over) then
    dcube:update(delta)

    for i = 1, #cubes do
      cubes[i]:update(delta)
    end
  end
end

function love.draw()
  graphics.setColor(1, 1, 1, 1)
  camera:attach()
  world:draw(1)

  graphics.push()

  for i = 1, #clouds do
    clouds[i]:draw()
  end

  grass:draw()
  dcube:draw()

  for i = 1, #cubes do
    cubes[i]:draw()
  end

  graphics.setColor(0, 0, 0, 1)

  graphics.pop()
  graphics.print(score, 30, 20, 0, 2.5, 2.5, 0.5, 0.5)

  if (over) then
    graphics.print("press \"r\" for restart the game", cw / 3, ch - 50, 0, 1.5, 1.5, 0.5, 0.5)
  end

  camera:detach()
  camera:draw()
end

function love.keypressed(key)
  if (key == "return") then
    sound.cube_tap:play()
    local cube = elite:extend({
      filename = "wood.png",
      scale = {x = dcube.scale.x, y = dcube.scale.y},
      update = function(self, delta)
        if (self.body:enter("grass")) then
          sound.playCollision()
          if (not landed) then
            score = score + 50
            landed = true
          else
            over = true
            sound.over:play()
            camera:shake(8, 1, 60, "XY")
          end
        elseif (self.body:enter("cube")) then
          sound.playCollision()

          local sx = self.body:getX()
          local sy = self.body:getY()
          local cx = cubes[#cubes].body:getX()
          local cy = cubes[#cubes].body:getY()

          if (sx == cx and sy == cy - (self.width / 2)) then
            score = score + 100
            sound.switch:play()
          else
            score = score + 20
          end
        end
      end,
      draw = function(self)
        graphics.draw(
          self.image, self.body:getX(), self.body:getY(),
          0, self.scale.x, self.scale.y,
          self.width / 2, self.height / 2
        )
      end
    })
    cube:setMode("norm")
    cube:load() cube.x = dcube.x
    cube.y = dcube.y + dcube.height
    cube.body = world:newRectangleCollider(cube.x, cube.y, cube.width * cube.scale.x, cube.height * cube.scale.y)
    cube.body:setCollisionClass("cube")
    cube.body:setType("dynamic")
    table.insert(cubes, cube)
  elseif (key == "r" and over) then
    -- TODO save the score inside a file
    score = 0
    landed = false
    over = false
    for i = #cubes, 1, -1 do
      cubes[i].body:destroy()
      local cube = table.remove(cubes, i)
      cube = (cube ~= nil and nil or nil)
    end
  end
end
