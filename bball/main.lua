function love.load()
  class = require("libs.class")
  object = require("libs.object")
  utils = require("libs.utils")
  sounds = require("libs.sounds")

  cw = love.graphics.getWidth()
  ch = love.graphics.getHeight()

  -- loading text objects
  textObj = {}
  titles = {"play game", "show level", "exit game"}

  for i = 1, 3 do
    table.insert(textObj, class:extend({
      text = titles[i],
      x = (cw / 2) - 25,
      y = 100 + (50 * i)
    }))
    
    if (i == 1) then
      textObj[i].xscale = 2
      textObj[i].yscale = 2
    else
      textObj[i].xscale = 1
      textObj[i].yscale = 1
    end
  end
  --
  
  -- loading cubes
  cube = {} 
  cube.image = {}

  for i = 1, 6 do
    table.insert(cube.image, love.graphics.newImage("images/flat" .. i .. ".png"))
  end

  cube.width = cube.image[1]:getWidth()
  cube.height = cube.image[1]:getHeight()
  --
  
  currentLevel = 1
end

function love.update(dt)

end

function love.draw()
  for i, v in ipairs(textObj) do
    textObj[i]:print()
  end
end

function love.keypressed(key)
  if (key == "j") or (key == "down") then
    utils.checkindex(textObj, 1, sounds.switch)
  elseif (key == "k") or (key == "down") then
    utils.checkindex(textObj, 0, sounds.switch) 
  end

  if (key == "return") then
    for i = 1, #textObj do
      if (textObj[i].xscale == 2) or (textObj[i].yscale == 2) then
        if (textObj[i].text == titles[1]) then
          for k, v in pairs(textObj) do
            textObj[k] = nil
          end

          function love.draw() 
            for i, row in ipairs(utils.tilemap[currentLevel]) do
              for j, num in ipairs(row) do
                love.graphics.draw(cube.image[num], j * cube.width, i * cube.height) 
              end
            end
          end
        elseif (textObj[i].text == titles[2]) then

        elseif (textObj[i].text == titles[3]) then

        end
      end
    end
  end
end
