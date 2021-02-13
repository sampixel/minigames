function love.load()
  character = {}
  character.image = love.graphics.newImage("images/animations.png")
  character.width = character.image:getWidth()
  character.height = character.image:getHeight()
  character.frames = {}
  character.numframes = 6
  character.frame_w = 200
  character.frame_h = 200
  character.x = 300
  character.y = 300

  for i = 0, character.numframes-1 do
    table.insert(
      character.frames,
      love.graphics.newQuad(
        i * character.frame_w, 0,
        character.frame_w, character.frame_h,
        character.width, character.height
      )
    )
  end

  currentframe = 1
end

function love.update(dt)
  currentframe = currentframe + (10 * dt)
  if (currentframe >= character.numframes) then
    currentframe = 1
  end
end

function love.draw()
  love.graphics.draw(character.image, character.frames[math.floor(currentframe)], character.x, character.y)
end
