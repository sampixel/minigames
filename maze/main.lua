local graphics = love.graphics
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local windfield = require("libs.windfield")
local tilemap = require("libs.tilemap")
local elite = require("libs.elite")
local cam = require("libs.camera")

function love.load()
  elite.setImageDir("images")
  camera = cam()

  world = windfield.newWorld(0, 0, false)
  world:addCollisionClass("player")
  world:addCollisionClass("block")

  player = elite:extend(require("items.player"))
  player:setMode("quad")
  player:load(5)
  player.body = world:newRectangleCollider(player.x, player.y, player.frame.width, player.frame.height)
  player.body:setCollisionClass("player")
  player.body:setType("dynamic")

  blocks = {}
  for i = 0, #tilemap - 1 do
    for j = 0, #tilemap[i+1] - 1 do
      local num = tilemap[i+1][j+1]
      if (num > 0 and num < 3) then
        local block = elite:extend({
          filename = "tile-" .. num .. ".png",
          scale = {x = 0.5, y = 0.5}
        })
        
        block:setMode("norm")
        block:load(1)
        block.x = j * block.width
        block.y = i * block.height

        if (num == 1) then
          block.body = world:newRectangleCollider(j * block.width, i * block.height, block.width, block.height)
          block.body:setCollisionClass("block")
          block.body:setType("static")
        end

        table.insert(blocks, block)
      end
    end
  end

  graphics.setBackgroundColor(1, 0.5, 0.14, 1)
end

function love.update(delta)
  camera:update(delta)
  camera:follow(player.body:getX(), player.body:getY())
  world:update(delta)
  player:update(delta, 5)
end

function love.draw()
  camera:attach()
  world:draw(1)

  for i = 1, #blocks do
    blocks[i]:draw()
  end

  player:draw()
  camera:detach()
  camera:draw()
end

function love.keypressed(key)
  if (key == player.button.top) then
    player:animate("walk", "top")
  elseif (key == player.button.bottom) then
    player:animate("walk", "bottom")
  elseif (key == player.button.right) then
    player:animate("walk", "right")
  elseif (key == player.button.left) then
    player:animate("walk", "left")
  end
end

function love.keyreleased(key)
  if (key == player.button.top) then
    player:animate("idle", "top")
  elseif (key == player.button.bottom) then
    player:animate("idle", "bottom")
  elseif (key == player.button.right) then
    player:animate("idle", "right")
  elseif (key == player.button.left) then
    player:animate("idle", "left")
  end
end
