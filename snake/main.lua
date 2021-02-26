function love.load()
  class = require("libs.class")

  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  point = {}
  point.x = math.random(CW)
  point.y = math.random(CH)
  point.width = 10
  point.height = point.width
  point.update = function(self, tbl)
    if (self.x == tbl[1].x) and (self.y == tbl[1].y) then
      self.x = math.random(CW)
      self.y = math.random(CH)

      table.insert(tbl, class:extend({
        width = self.width,
        height = self.height,
        x = tbl[#tbl].x,
        y = tbl[#tbl].y,
        top = tbl[1].top,
        bottom = tbl[1].bottom,
        left = tbl[1].left,
        right = tbl[1].right
      }))
    end
  end

  snake = {}
  snake[1] = class:extend({
    width = point.width,
    height = point.height,
    x = CW/2,
    y = CH/2,
    top = false,
    bottom = false,
    left = false,
    right = false
  })

  time = 0
end


function love.update(dt)
  point:update(snake)

  time = time + dt
  if (time >= 0.1) then
    for i, _ in ipairs(snake) do
      snake[i]:update(dt)
    end
    time = 0
  end
end


function love.draw()
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.rectangle("fill", point.x, point.y, point.width, point.height)

  love.graphics.setColor(0, 1, 0, 1)
  for i, _ in ipairs(snake) do
    love.graphics.rectangle(i % 2 == 0 and "fill" or "line", snake[i].x, snake[i].y, snake[i].width, snake[i].height) 
  end
end


function love.keypressed(key)
  for i, _ in ipairs(snake) do
    if (key == "h") then
      snake[i]:direction("left")
    elseif (key == "j") then
      snake[i]:direction("bottom")
    elseif (key == "k") then
      snake[i]:direction("top")
    elseif (key == "l") then
      snake[i]:direction("right")
    end
  end
end
