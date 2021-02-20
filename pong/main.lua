function love.load()
  CW = love.graphics.getWidth()
  CH = love.graphics.getHeight()

  pong = {}
  pong.speedX = 150
  pong.speedY = 150
  pong.width = 5
  pong.height = 5
  pong.x = CW/2 - pong.width/2
  pong.y = CH/2 - pong.height/2

  player = {}

  player.left = {}
  player.left.score = 0
  player.left.speed = 300
  player.left.width = 10
  player.left.height = 50
  player.left.x = player.left.width/2
  player.left.y = CH/2 - player.left.height/2

  player.right = {}
  player.right.score = 0
  player.right.speed = 300
  player.right.width = player.left.width
  player.right.height = player.left.height
  player.right.x = CW - (player.right.width*2)
  player.right.y = CH/2 - player.right.height/2
end

function love.update(dt)
  pong.x = pong.x + pong.speedX * dt
  pong.y = pong.y + pong.speedY * dt

  if (pong.x <= 0) then
    player.right.score = player.right.score + 1
    pong.x = CW/2 - pong.width/2
    pong.y = CH/2 - pong.height/2
  elseif (pong.x + pong.width >= CW) then
    player.left.score = player.left.score + 1
    pong.x = CW/2 - pong.width/2
    pong.y = CH/2 - pong.height/2
  elseif (pong.y <= 0) then
    pong.speedY = -pong.speedY
  elseif (pong.y + pong.height >= CH) then
    pong.speedY = -pong.speedY
  elseif ((pong.x <= player.left.x + player.left.width) and
        (pong.y <= player.left.y + player.left.height) and
        (pong.y + pong.height >= player.left.y)) then
    pong.speedX = -pong.speedX
  elseif ((pong.x + pong.width >= player.right.x) and
        (pong.y <= player.right.y + player.right.height) and
        (pong.y + pong.height >= player.right.y)) then
      pong.speedX = -pong.speedX
  end

  if (player.left.y <= 0) then
    player.left.y = 0
  end
  
  if (player.right.y <= 0) then
    player.right.y = 0
  end

  if (player.left.y + player.left.height >= CH) then
    player.left.y = CH - player.left.height
  end
  
  if (player.right.y + player.right.height >= CH) then
    player.right.y = CH - player.right.height
  end

  if (love.keyboard.isDown("w")) then
    player.left.y = player.left.y - player.left.speed * dt
  elseif (love.keyboard.isDown("lshift")) and (love.keyboard.isDown("w")) then
    player.left.y = player.left.y - player.left.speed + 100 * dt
  end

  if (love.keyboard.isDown("s")) then
    player.left.y = player.left.y + player.left.speed * dt
  elseif (love.keyboard.isDown("lshift")) and (love.keyboard.isDown("s")) then
    player.left.y = player.left.y + player.left.speed + 100 * dt
  end

  if (love.keyboard.isDown("k")) then
    player.right.y = player.right.y - player.right.speed * dt
  elseif (love.keyboard.isDown("rshift")) and (love.keyboard.isDown("k")) then
    player.right.y = player.right.y - player.right.speed + 100 * dt
  end

  if (love.keyboard.isDown("j")) then
    player.right.y = player.right.y + player.right.speed * dt
  elseif (love.keyboard.isDown("rshift")) and (love.keyboard.isDown("j")) then
    player.right.y = player.right.y + player.right.speed + 100 * dt
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", pong.x, pong.y, pong.width, pong.height)

  love.graphics.print(player.left.score, CW/3 - (player.left.width*2), player.left.height/2, 0, 3, 3)
  love.graphics.print(player.right.score, CW/1.5 + (player.right.width*2 - player.right.width/2), player.right.height/2, 0, 3, 3)

  love.graphics.rectangle("fill", player.left.x, player.left.y, player.left.width, player.left.height)
  love.graphics.rectangle("fill", player.right.x, player.right.y, player.right.width, player.right.height)
end
