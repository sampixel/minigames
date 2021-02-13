function love.load()
  class = require("libs.class")
  object = require("libs.object")
  sounds = require("libs.sounds")

  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()
  
  back = class:extend(object["back"])
  back:load()

  vboxes =  {}
  vboxesLanded = {}
  cube = class:extend(object["cube"])
  cube:load()
  cube.width = cube.width / 2
  cube.height = cube.height / 2

  plats = {}
  for i = 1, 7 do
    table.insert(plats, {
      image = love.graphics.newImage("images/platform.png"),
    })

    plats[i].width = plats[i].image:getWidth() / 2
    plats[i].height = plats[i].image:getHeight() / 2
  end

  gameover = class:extend(object["gameover"])
  gameover:load()

  isLandedOverPlatform = false
  isGameOver = false

  sounds.backmusic:play()
end

function love.update(dt)
  if not (isGameOver) then
    cube:update(dt)

    if (cube.toRight) then
      back.x = back.x - back.speed * dt
    elseif (cube.toLeft) then
      back.x = back.x + back.speed * dt
    end

    for i, _ in ipairs(vboxes) do
      if not (vboxes[i].isLanded) then
        -- check for collision with platform
        if not (isLandedOverPlatform) then
          if (vboxes[i].y + vboxes[i].height >= CH - plats[1].height) then
            sounds.playCollisionSound()
            table.insert(vboxesLanded, vboxes[i])
            vboxes[i].y = CH - plats[1].height - vboxes[i].height
            vboxes[i].isLanded = true
            isLandedOverPlatform = true
          end
        else
          -- check for collision with other blocks
          if (vboxes[i].x) >= (vboxesLanded[#vboxesLanded].x - vboxes[i].width/2) and
              (vboxes[i].x) <= (vboxesLanded[#vboxesLanded].x + vboxes[i].width/2) then
            if (vboxes[i].y + vboxes[i].height) >= (CH - plats[1].height - vboxes[i].height * #vboxesLanded) then
              sounds.playCollisionSound()
              vboxes[i].y = CH - plats[1].height - vboxes[i].height * (#vboxesLanded + 1)
              vboxes[i].isLanded = true
              print(#vboxesLanded)
              table.insert(vboxesLanded, vboxes[i])
            end
          else
            if (vboxes[i].y + vboxes[i].height) >= (CH - plats[1].height) then
              sounds.gameover:play()
              vboxes[i].isLanded = true
              isGameOver = true
            end
          end
        end
            
        -- remove speed to block
        if (vboxes[i].isLanded) then
          vboxes[i].speed = nil
        else
          vboxes[i].y = vboxes[i].y + vboxes[i].speed * dt
          vboxes[i].speed = vboxes[i].speed + 15
        end
      end
    end
  end
end

function love.draw()
  back:draw()
  cube:draw()

  for i = 0, #plats-1 do
    love.graphics.draw(
      plats[i+1].image,
      i * plats[i+1].width * 2,
      CH - plats[i+1].height
    )
  end

  for i, _ in ipairs(vboxes) do
    love.graphics.draw(vboxes[i].image, vboxes[i].x, vboxes[i].y, 0, vboxes[i].xs, vboxes[i].ys)
  end

  if (isGameOver) then
    gameover:draw()
  end
end

function love.keypressed(key)
  if not (isGameOver) then
    if (key == "return") or (key == "space") then
      sounds.landbox:play()

      table.insert(vboxes, {
        image = love.graphics.newImage("images/vbox.png"),
        speed = 100,
        isLanded = false,
        x = cube.x, y = cube.y + cube.height,
        width = cube.width, height = cube.height,
        xs = 0.5, ys = 0.5
      })

      cube.speed = (cube.speed >= 150) and 150 or (cube.speed + 5)
    end
  end
end
