function love.load()
  class = require("libs.class")           -- require class module
  object = require("libs.object")         -- require object module
  utils = require("libs.utils")           -- require utils module
  tilemap = require("libs.tilemap")       -- require tilemap
  windfield = require("libs.windfield")   -- require physics

  Camera = require("libs.camera")    -- require camera
  camera = Camera()

  --_isDebug = 255
  world = windfield.newWorld(0, 0, false) -- create new world
  world:setGravity(0, 9.81*128)           -- set gravity
  world:addCollisionClass("player")       -- add collision class for player
  world:addCollisionClass("box")          -- add collision class for box
  world:addCollisionClass("platform")     -- add collision class for platform

  cw = love.graphics.getWidth()   -- content width
  ch = love.graphics.getHeight()  -- content height

  boxes = {}  -- load boxes table
  plats = {}  -- load plats table
  for i = 0, #tilemap.level[1] - 1 do     -- load level design
    for j = 0, #tilemap.level[1][i+1] - 1 do
      local index_lev = tilemap.level[1][i+1][j+1]
      if (index_lev >= 1 and index_lev <= 6) then
        local plat = class:extend({
          filename = "plat_" .. index_lev .. ".png",
          scale = {x = 0.5, y = 0.5}
        })
        plat:load()
        plat:rescale()
        plat.body = world:newRectangleCollider(j * plat.width, i * plat.height, plat.width, plat.height)
        plat.body:setCollisionClass("platform")
        plat.body:setType("static")
        table.insert(plats, plat)
      elseif (index_lev == 7) then
        local box = class:extend({
          filename = "box.png",
          scale = {x = 0.5, y = 0.5}
        })
        box:load()
        box:rescale()
        box.body = world:newRectangleCollider(j * box.width, i * box.height, box.width, box.height)
        box.body:setCollisionClass("box")
        box.body:setType("dynamic")
        table.insert(boxes, box)
      elseif (index_lev == 9) then
  player = class:extend(object.player)  -- load player
  player:load()
  player.frame_width = player.width * player.scale.x / player.num_frame_per_width
  player.frame_height = player.height * player.scale.y / player.num_frame_per_height
  player.body = world:newRectangleCollider(j * player.frame_width, i * player.frame_height, player.frame_width - 2, player.frame_height - 2)
  --player.body = world:newRectangleCollider(player.x, player.y, player.frame_width - 2, player.frame_height - 2)
  player.body:setCollisionClass("player")
  player.body:setRestitution(0.08)
  player.body:setType("dynamic")
  player.frames = {}
  player.current_frame = 1
  for i = 0, player.num_frame_per_height - 1 do
    local size = 64
    for j = 0, player.num_frame_per_width - 1 do
      table.insert(player.frames, love.graphics.newQuad(
          1 + (j * size), 1 + (i * size), size - 2, size - 2,
          player.width, player.height
        )
      )
    end
  end
end
end
end

  love.graphics.setBackgroundColor(0.4, 0.5, 0.9)  -- set background color
end

function love.update(delta)
  camera:update(delta)  -- update and follow camera
  camera:follow(player.body:getX(), player.body:getY())

  world:update(delta)   -- update world

  player:update(delta)  -- update player

  for i = 1, #boxes do  -- update boxes
    local box = boxes[i]
    box.body:setAngle(0)
    if (box.catched) then
      box.body:setX(player.body:getX())
      box.body:setY(player.body:getY() - (box.height - 5))
      break
    end
  end
end

function love.draw()
  camera:attach()
  
  world:draw(_isDebug or 0)

  for i = 1, #plats do  -- draw platforms
    plats[i]:draw()
  end

  for i = 1, #boxes do  -- draw boxes 
    boxes[i]:draw()
  end

  love.graphics.draw( -- draw player's frame
    player.image, player.frames[math.floor(player.current_frame)],
    player.body:getX(), player.body:getY(),
    0, player.scale.x, player.scale.y,
    player.frame_width, player.frame_height
  )

  camera:detach()
  camera:draw()
end

function love.keypressed(key)
  if (key == "k") then
    local _, vy = player.body:getLinearVelocity() -- get player's velocity
    if not (vy < -1 or vy > 1) then               -- to allow player to jump once at time
      player.body:applyForce(0, (player.busy and -60000 or -35000))
      player:animate("normal", "jump")
    end
  elseif (key == "h") then
    player.prev_direction = "left"
  elseif (key == "l") then
    player.prev_direction = "right"
  elseif (key == "e" and player:collision(boxes)) then
    player:catch(boxes[player.box_index])
  elseif (key == "r" and player.busy) then
    player:release(boxes[player.box_index])
  elseif (key == "q") then
    love.event.quit("restart")
  end
end

function love.keyreleased(key)
  if (key == "h" or key == "l") then
    player:animate("normal", "idle")
  end
end
