function love.load()
  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  crunch = love.audio.newSource("audio/crunch.wav", "stream")
  bite = love.audio.newSource("audio/bite.wav", "stream")

  time = 0
  gap = 0.1
  count = 0
  size = (CW % 50 == 0 and CH % 50 == 0) and 50 or 20
  arrayX = {}
  arrayY = {}

  point = {}
  point.width = size
  point.height = point.width
  point.x = point.width*5
  point.y = point.height*4
  point.checkPosition = function(self)
    repeat
      self.x = math.random(CW-self.width)
      self.y = math.random(CH-self.height)
    until (self.x % self.width == 0) and (self.y % self.height == 0)
  end
  
  snake = {}
  snake[1] = {
    text = "snake lenght: ",
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
        self.button[k] = (k == key) and true or false
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
    crunch:play()

    arrayX[#arrayX+1] = arrayX[#arrayX]
    arrayY[#arrayY+1] = arrayY[#arrayY]

    table.insert(snake, {
      x = arrayX[#arrayX],
      y = arrayY[#arrayY],
      width = point.width,
      height = point.height
    })

    if (#snake % 6 == 0) then
      gap = (gap == 0) and (0) or (gap - 0.02)
    end

    point:checkPosition()
  end

  for i = 4, #snake do
    if ((snake[1].x == snake[i].x) and (snake[1].y == snake[i].y)) then
      bite:play()
      gap = 0.1

      for k, _ in pairs(snake[1].button) do
        snake[1].button[k] = false
      end
      
      for j = #snake, 2, -1 do
        table.remove(snake, j)
        table.remove(arrayX, j)
        table.remove(arrayY, j)
      end

      snake[1].x = CW/2 - snake[1].width/2
      snake[1].y = CH/2
      break
    end
  end

  time = time + dt
  if (time >= gap) then
    snake[1]:update()
    arrayX[1] = snake[1].x
    arrayY[1] = snake[1].y
    
    for i = #snake, 2, -1 do
      snake[i].x = arrayX[i]
      snake[i].y = arrayY[i]
    end
       
    for i = #snake, 1, -1 do
      arrayX[i+1] = arrayX[i]
      arrayY[i+1] = arrayY[i]
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

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(snake[1].text .. #snake, 50, 20, 0, 1.5, 1.5)
  love.graphics.print("gap: " .. gap, 50, 40, 0, 1.5, 1.5)
end


function love.keypressed(key)
  if ((key == "h") and not (snake[1].button.right)) then
    snake[1]:move("left")
  elseif ((key == "j") and not (snake[1].button.up))then
    snake[1]:move("down")
  elseif ((key == "k") and not (snake[1].button.down)) then
    snake[1]:move("up")
  elseif ((key == "l") and not (snake[1].button.left)) then
    snake[1]:move("right")
  end
end
