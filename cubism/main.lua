function love.load()
  tileset = require("libs.tileset")
  
  -- coordinates
  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  -- newfont
  font = {name = "Spyro2-nZvM.ttf", size = 35}
  love.graphics.setFont(love.graphics.newFont(font.name, font.size))

  time = 0
  
  game_title = {}

  -- cubism title
  for row = 1, #tileset.title do
    table.insert(game_title, {})

    for col = 1, #tileset.title[row] do
      table.insert(game_title[row], {
        image = love.graphics.newImage("images/cube.png"),
        rotation = 0,
        speed = 30
      })

      local last = game_title[row][col]
      last.width = last.image:getWidth()
      last.height = last.image:getHeight()
      last.x = (CW/7) + (last.width * col)
      last.y = 100 + (last.height * row)
    end
  end

  -- texts position
  buttons = {
    left =  {text = "left: ", key = "h", x = CW/6},
    top =   {text = "jump: ", key = "k", x = CW/2.5},
    right = {text = "right: ",key = "l", x = CW/1.5}
  }

  -- line
  ground = {}
  ground.x1 = 0
  ground.y1 = CH - 100
  ground.x2 = CW
  ground.y2 = CH - 100

  -- player cube
  cube = {}
  cube.image = love.graphics.newImage("images/cube.png")
  cube.width = cube.image:getWidth()
  cube.height = cube.image:getHeight()
  cube.x = CW/2
  cube.y = ground.y1 - (cube.height/2)
  cube.rotation = 0
  cube.scaleX = 1
  cube.scaleY = 1
  cube.speed = 100
end


function love.update(dt)
  time = time + dt

  -- rotate cubism title
  if (time > 0.05) then
    for row, _ in ipairs(game_title) do
      for col, v in ipairs(game_title[row]) do
        v.rotation = v.rotation + (row * dt)
      end
    end

    time = 0
  end

  -- cube movement
  if (love.keyboard.isDown(buttons.left.key)) then
    cube.x = cube.x - (cube.speed * dt) 
    cube.rotation = cube.rotation - (cube.speed * dt)
  elseif (love.keyboard.isDown(buttons.right.key)) then
    cube.x = cube.x + (cube.speed * dt) 
    cube.rotation = cube.rotation + (cube.speed * dt)

    for row, _ in ipairs(game_title) do
      for col, v in ipairs(game_title[row]) do
        v.x = v.x - (v.speed * dt)
      end
    end

    for k, v in pairs(buttons) do
      v.x = v.x - ((cube.speed/2) * dt)
    end
  elseif (love.keyboard.isDown(buttons.top.key)) then

  end
end


function love.draw()
  -- cubism title
  for row, _ in ipairs(game_title) do
    for col, v in ipairs(game_title[row]) do
      if (tileset.title[row][col] ~= 0) then
        love.graphics.draw(v.image, v.x, v.y, v.rotation, 1, 1, v.image:getWidth()/2, v.image:getHeight()/2)
      end
    end
  end

  -- texts position
  for _, v in pairs(buttons) do
    love.graphics.print(v.text .. v.key, v.x, CH - 50)
  end

  -- line
  love.graphics.line(ground.x1, ground.y1, ground.x2, ground.y2)

  -- player cube
  love.graphics.draw(
    cube.image, cube.x, cube.y, cube.rotation,
    cube.scaleX, cube.scaleY, cube.image:getWidth()/2, cube.image:getHeight()/2
  )
end
