local graphics = love.graphics
local keyboard = love.keyboard
local random = love.math.random
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local windfield = require("libs.windfield")
local stalkerx = require("libs.camera")
local tilemap = require("libs.tilemap")
local sound = require("libs.sound")

local player = require("items.player")
local enemy = require("items.enemy")
local block = require("items.block")
local long_block = require("items.long_block")

function love.load()
  graphics.setFont(graphics.newFont("fonts/AtariFontFullVersion-ZJ23.ttf", 12))
  graphics.setBackgroundColor(0.9, 0.3, 0.25, 1)

  world = windfield.newWorld(0, 0, false)
  world:setGravity(0, 9.81 * 128)
  world:addCollisionClass("player")
  world:addCollisionClass("enemy")
  world:addCollisionClass("block")
  world:addCollisionClass("long-block")

  camera = stalkerx()

  stars = {}
  for i = 1, 50 do
    table.insert(stars, {
      x = random(0, cw),
      y = random(0, ch),
      width = 1,
      height = 1,
      speed = {
        x = random(0, 1) == 1 and random(10, 30) or random(-30, -10),
        y = random(0, 1) == 1 and random(10, 30) or random(-30, -10)
      },
      update = function(self, delta)
        self.x = random(0, 1) == 1 and self.x + (self.speed.x * delta) or self.x - (self.speed.x * delta)
        self.y = random(0, 1) == 1 and self.y + (self.speed.x * delta) or self.y - (self.speed.y * delta)

        if (self.x + self.width < 0) then
          self.x = cw
          self.y = random(0, ch)
        elseif (self.x > cw) then
          self.x = 0 - self.width
          self.y = random(0, ch)
        elseif (self.y + self.height < 0) then
          self.y = ch
          self.x = random(0, cw)
        elseif (self.y > ch) then
          self.y = 0 - self.height
          self.x = random(0, cw)
        end
      end,
      draw = function(self)
        graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      end
    })
  end

  blocks = {}
  enemies = {}
  for i = 1, #tilemap do
    for j = 1, #tilemap[i] do
      local tile = tilemap[i][j]

      if (tile == 1) then
        local block = block:extend()
        block.width = block.image:getWidth()
        block.height = block.image:getHeight()
        block.x = j * block.width
        block.y = i * block.height
        block.body = world:newRectangleCollider(block.x, block.y, block.width, block.height)
        block.body:setCollisionClass("block")
        block.body:setType("kinematic")
        block.body:setObject(block)
        table.insert(blocks, block)
      elseif (tile == 2) then
        local block = long_block:extend()
        block.width = block.image:getWidth()
        block.height = block.image:getHeight()
        block.x = j * (block.width / 2)
        block.y = i * block.height
        block.body = world:newRectangleCollider(block.x, block.y, block.width, block.height)
        block.body:setCollisionClass("long-block")
        block.body:setType("static")
        block.body:setObject(block)
        table.insert(blocks, block)
      elseif (tile == 7) then

      elseif (tile == 8) then
        local enemy = enemy:extend()
        enemy.width = enemy.image:getWidth()
        enemy.height = enemy.image:getHeight()
        enemy.x = j * enemy.width
        enemy.y = i * enemy.height
        enemy.body = world:newRectangleCollider(enemy.x, enemy.y, enemy.width, enemy.height)
        enemy.body:setCollisionClass("enemy")
        enemy.body:setType("dynamic")
        enemy.body:setObject(enemy)
        table.insert(enemies, enemy)
      elseif (tile == 9) then
        player = require("items.player")
        player.x = j * player.width
        player.y = i * player.height
        player.body = world:newRectangleCollider(player.x, player.y, player.width, player.height)
        player.body:setRestitution(0.3)
        player.body:setCollisionClass("player")
        player.body:setType("dynamic")
        player.body:setObject(player)
      elseif (tile == 10) then
        guide = {}
        guide.text = [[("a") left - ("d") right - ("w") jump]]
        guide.x = 16 * j
        guide.y = (16 * i) + 16
        guide.scale = {x = 0.7, y = 1}
        guide.draw = function(self)
          graphics.print(self.text, self.x, self.y, 0, self.scale.x, self.scale.y)
        end
      end
    end
  end
end

function love.update(delta)
  camera:update(delta)
  camera:follow(player.body:getX(), player.body:getY())
  world:update(delta)
  player:update(delta)

  if (player.body:enter("enemy")) then
    camera:shake(8, 1, 60, "XY")
  end

  for i = 1, #stars do stars[i]:update(delta) end
  for i = 1, #player.lifes do player.lifes[i]:update(delta) end
  for i = 1, #enemies do enemies[i]:update(delta) end

  for i = 1, #blocks do
    if (blocks[i].update) then
      blocks[i]:update(delta)
    end
  end

  for i = #player.cubes, 1, -1 do
    player.cubes[i]:update(delta)
    if (player.cubes[i].time > 0.2) then
      local child = table.remove(player.cubes, i)
      child = (child ~= nil and nil)
    end
  end
end

function love.draw()
  camera:attach()
  world:draw(1)

  graphics.setColor(0, 0, 0, 1)
  for i = #stars, 1, -1 do stars[i]:draw() end

  graphics.setColor(1, 1, 1, 1)
  for i = #blocks, 1, -1 do blocks[i]:draw() end
  for i = #enemies, 1, -1 do enemies[i]:draw() end

  player:draw()

  for i = #player.lifes, 1, -1 do player.lifes[i]:draw() end

  graphics.setColor(0, 0, 0, 1)
  guide:draw()

  camera:detach()
  camera:draw()
end

function love.keypressed(key)
  if (key == "k") then
    player:jump(8000)
  end
end
