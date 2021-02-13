function love.load()
  tilemap = {
    {1, 1, 1, 1, 4, 4, 4, 6, 6, 6},
    {0, 1, 0, 3, 0, 2, 0, 3, 3, 3},
    {1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 2, 0, 0, 0, 4, 5, 0, 0, 1},
    {3, 4, 2, 3, 1, 5, 2, 1, 4, 6}
  }
  --[[
  image = love.graphics.newImage("images/tile.png")
  width = image:getWidth()
  height = image:getHeight()
  --]]

  image = love.graphics.newImage("images/tileset.png")
  width = image:getWidth()
  height = image:getHeight()
  tile_w = (width / 3) - 2
  tile_h = (height / 2) - 2

  -- create the quads
  quads = {}

  for i = 0, 1 do
    for j = 0, 2 do
      table.insert(quads,
        love.graphics.newQuad(
          1 + j * (tile_w + 2),
          1 + i * (tile_h + 2),
          tile_w, tile_h,
          width, height
        )
      )
    end
  end

  player = love.graphics.newImage("images/player.png")
  p_width = player:getWidth()
  p_height = player:getHeight()
  px = math.random(#tilemap)
  py = math.random(#tilemap[1])
  --
end

function love.update(dt)

end

function love.draw()
  for i, row in ipairs(tilemap) do
    for j, tile in ipairs(row) do
      if (tile ~= 0) then
        love.graphics.draw(image, quads[tile], j * tile_w, i * tile_h)
      end
    end
  end

  love.graphics.draw(player, px * tile_w, py * tile_h)
  --[[
  for i, row in ipairs(tilemap) do
    for j, tile in ipairs(row) do
      if (tile == 1) then
        love.graphics.setColor(0, 0, 1)
      elseif (tile == 2) then
        love.graphics.setColor(0, 1, 0)
      elseif (tile == 3) then
        love.graphics.setColor(1, 0, 0)
      end
      love.graphics.draw(image, j * width, i * height)
    end
  end
  --]]
end

function love.keypressed(key)
  local xpos = px
  local ypos = py

  if (key == "h") then
    xpos = xpos - 1
  elseif (key == "j") then
    ypos = ypos + 1
  elseif (key == "k") then
    ypos = ypos - 1
  elseif (key == "l") then
    xpos = xpos + 1
  end

  if (tilemap[xpos][ypos] == 0) then
    print(string.format("tilemap[%d][%d]", xpos, ypos))
    px = xpos
    py = ypos
  else
    print("px: " .. px, "py: " .. py)
  end
end
