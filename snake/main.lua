function love.load()
  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  time = 0
  arrayX = {}
  arrayY = {}

  point = {}
  point.x = math.random(CW)
  point.y = math.random(CH)
  point.width = 20
  point.height = point.width
  
  snake = {}
  snake[1] = {
    button = {
      up = false,
      down = false,
      left = false,
      right = false
    },
    width = point.width,
    height = point.height,
    x = CW/2,
    y = CH/2,
    update = function(self)
      if (self.x < 0) then
        self.x = CW
      elseif (self.x + self.width > CW) then
        self.x = 0 - self.width
      elseif (self.y < 0) then
        self.y = CH
      elseif (self.y + self.height > CH) then
        self.y = 0 - self.height
      end

      if (self.button.down) then
        self.y = self.y + self.height
      elseif (self.button.up) then
        self.y = self.y - self.height
      elseif (self.button.left) then
        self.x = self.x - self.width
      elseif (self.button.right) then
        self.x = self.x + self.width
      end
    end,
    move = function(self, key)
      for k, _ in pairs(self.button) do
        if (k == key) then
          self.button[k] = true
        else
          self.button[k] = false
        end
      end
    end,
    collision = function(self, object)
      if ((object.x + object.width > self.x) and (object.x < self.x + self.width) and
          (object.y + object.height > self.y) and (object.y < self.y + self.height)) then
        return true
      end
      return false
    end
  }
end


function love.update(dt)
  if (snake[1]:collision(point)) then
    for i = #arrayX, 2, -1 do
      arrayX[i+1] = arrayX[i]
      arrayY[i+1] = arrayY[i]
    end

    table.insert(snake, {
      x = arrayX[#arrayX],
      y = arrayY[#arrayY],
      width = point.width,
      height = point.height
    })
    
    repeat
      point.x = math.random(CW-point.width)
      point.y = math.random(CH-point.height)
    until (point.x % point.width == 0) and (point.y % point.height == 0)
  end

  time = time + dt
  if (time >= 0.1) then
    snake[1]:update()

    arrayX[1] = snake[1].x
    arrayY[1] = snake[1].y
    
    --[[
    for i = 1, #snake do
      arrayX[i] = snake[i].x
      arrayY[i] = snake[i].y
    end
    --]]
    
    for i = #snake, 2, -1 do
      snake[i].x = arrayX[#arrayX]
      snake[i].y = arrayY[#arrayY]
      --snake[i].x = arrayX[#arrayX-i+2]
      --snake[i].y = arrayY[#arrayY-i+2]
    end

    time = 0
  end
end


function love.draw()
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.rectangle("fill", point.x, point.y, point.width, point.height)

  love.graphics.setColor(0, 1, 0, 1)
  for i, _ in ipairs(snake) do
    love.graphics.rectangle("fill", snake[i].x, snake[i].y, snake[i].width, snake[i].height) 
  end
end


function love.keypressed(key)
  if (key == "h") then
    snake[1]:move("left")
  elseif (key == "j") then
    snake[1]:move("down")
  elseif (key == "k") then
    snake[1]:move("up")
  elseif (key == "l") then
    snake[1]:move("right")
  end
end
